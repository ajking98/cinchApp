//
//  ProfilePageViewController.swift
//  
//
//  Created by Ahmed Gedi on 6/22/19.
//

import UIKit
import MobileCoreServices

class ProfilePageViewController: UIViewController {
    var username: String = ""
    var isLocalUser: Bool = true
    
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var numberOfFollowersLabel: UILabel!
    @IBOutlet weak var numberOfFollowingsLabel: UILabel!
    @IBOutlet weak var numberOfGemsLabel: UILabel!
    
    // Stats Views
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var followerStack: UIStackView!
    @IBOutlet weak var firstBreak: UIView!
    @IBOutlet weak var followingsStack: UIStackView!
    @IBOutlet weak var secondBreak: UIView!
    @IBOutlet weak var GemsStack: UIStackView!
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editImage: UIButton!
    @IBOutlet weak var editProfile: UIButton!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var customSegmentedControl: UISegmentedControl!
    var firstView: UIView!
    var secondView: UIView!
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    var profileViewTapped = false
    
    @IBAction func editImage(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.profileUsername.isHidden = true
        let localUser = String(UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!)
        print("these are the two usernames:", username, " VS ", localUser)
        if username == ""  || username == localUser { //checks if the user is looking at their profile or someone else's 
            username = localUser
            followButton.isHidden = true
        }
        else {
            followButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFollowTapped)))
            UserStruct().readFollowing(user: localUser) { (followers) in
                if followers.values.contains(self.username) {
                    //make the button disabled and greyed out
                    self.followButton.isEnabled = false
                    self.followButton.backgroundColor = .darkGray
                    self.followButton.layer.opacity = 0.7
                }
            }
            settingsButton.isHidden = true
            editProfile.isHidden = true
            editImage.isHidden = true
        }
        buildStatView()
        fetchData()
    }
    
    @objc func handleFollowTapped() {
        let localUser = String(UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!)
        UserStruct().addFollower(user: username, newFollower: localUser) //the local user is a follower of the actual user
        UserStruct().addFollowing(user: localUser, newFollowing: username)
        
        //make the button disabled and greyed out
        self.followButton.isEnabled = false
        self.followButton.backgroundColor = .darkGray
        self.followButton.layer.opacity = 0.7
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.set(nil, forKey: defaultsKeys.otherProfile)
    }
    
    func buildStatView() {
        
    }
    
    @IBAction func toggleSideMenu(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Toggle Side Menu"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard isLocalUser else {
            if segue.identifier == "gemsSegue" {
                let vc = segue.destination as! GemsViewController
                vc.username = username
                vc.isLocalUser = isLocalUser
            }
            if segue.identifier == "foldersFollowingSegue" {
                let vc = segue.destination as! FolderReferenceController
                vc.username = username
                vc.isLocalUser = isLocalUser
            }
            
            return
        }
        if segue.identifier == "editProfileSegue" {
            let vc = segue.destination as! EditProfileViewController
            vc.profileImage = profileImage
            vc.profileName = profileName
            print("we are executing this")
        }
        
    }
    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            customSegmentedControl.tintColor = UIColor(red: 1/255.0, green: 209/255.0, blue: 151/255.0, alpha: 1.0)
            viewOne.alpha = 1
            viewTwo.alpha = 0
        case 1:
            customSegmentedControl.tintColor = UIColor(red: 1/255.0, green: 151/255.0, blue: 209/255.0, alpha: 1.0)
            viewOne.alpha = 0
            viewTwo.alpha = 1
        default:
            break
        }
    }
    
    func fetchData() {
        print("fetching data")
        UserStruct().readFollowers(user: username) { (followers) in
            self.numberOfFollowersLabel.text = String(followers.count)
        }
        
        UserStruct().readFollowing(user: username) { (followings) in
            self.numberOfFollowingsLabel.text = String(followings.count)
        }
        
        //sets the full name
        UserStruct().readName(user: username) { (name) in
            if (name == "") {
                self.profileName.text = "Add Name"
            } else {
                self.profileName.text = name
            }
        }
        
        //sets profile picture
        UserStruct().readProfilePic(user: username) { (link) in
            let url = URL(string: link)
            self.profileImage.sd_setImage(with: url, placeholderImage: UIImage(named: "empty"), completed: nil)
        }
        
        self.profileImage.contentMode = .scaleAspectFill
//        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
        
        profileUsername.text = username
        //TODO implement read number of Gems - Should be a stored value in the DB 
//        UserStruct().read
        
    }
    
}

extension ProfilePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImage.image = image
            let username = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)
            StorageStruct().uploadImage(image: image) { (string) in
                UserStruct().updateProfilePic(user: username!, newProfilePic: string)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}
