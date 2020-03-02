//
//  ProfileViewController.swift
/*
    1. Design the nav bar
    2. Build the profile image
 */
//  Created by Alsahlani, Yassin K on 1/28/20.
//

import UIKit
import MobileCoreServices

class ProfileViewController: UIViewController {
    
    //data
    var height: CGFloat = 0
    var width: CGFloat = 0
    var isUser = true
    
    var profileName = ""
    var username = ""
    var followers = 0
    var followings = 0
    var gems = 0
    var isFollowing = false
    var cellIdentifier = "Cell"
    
    //elements
    var scrollView = UIScrollView(frame: CGRect.zero)
    var profileImageView = UIImageView(frame: CGRect.zero)
    var backgroundProfileIcon = UIImageView(image: UIImage(named: "backgroundRing1"))
    var usernameLabel = UILabel(frame: CGRect.zero)
    var gemLabel = UILabel(frame: CGRect.zero)
    var addFolderButton = UILabel(frame: CGRect.zero)
    var numberOfGems = 0
    var stackView = ProfileStackView(frame: CGRect.zero)
    var mainButton = UIButton(frame: CGRect.zero) //this is the button that can either be "edit profile" or "follow/unfollow"
    var segmentControl = UISegmentedControl(items: ["Personal", "Following"])
    var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setupData()
        setupScrollView()
        setupNavigationBar()
        setupProfileImage()
//        setupUsernameLabel()
//        setupGemLabel()
//        stackView.setup(followings: followings, followers: followers, Gems: gems, view: view, scrollView: scrollView)
        setupButton()
        setupAddFolderButton()
        setupSegmentControl()
        setupSegmentControlBars()
        setupCollectionViews()
    }
    
    
    //TODO: Take a look at this
    func fetchData() {
        let localUser = String(UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!)
        print("these are the two usernames:", username, " VS ", localUser)
        if username == ""  || username == localUser { //checks if the user is looking at their profile or someone else's
            username = localUser
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = .white
        print("this is appearing")
        collectionView?.reloadData()
    }
    
    //sets the data - width, height, profileName, username, isUser, isFollowing etc.
    func setupData() {
        height = view.frame.height
        width = view.frame.width
        fetchProfilePic()
        fetchTitle()
        fetchIsFollowing()
    }
    
    ///Checks if local User is following the given username
    func fetchIsFollowing() {
        mainButton.setTitle("Follow", for: .normal)
        guard let localUser = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey) else { return }
        UserStruct().readFollowing(user: localUser) { (users) in
            if users.contains(self.username) {
                self.isFollowing = true
                self.mainButton.layer.borderWidth = 1.7
                self.mainButton.backgroundColor = .white
                self.mainButton.setTitle("Unfollow", for: .normal)
                self.mainButton.setTitleColor(.customRed, for: .normal)
                self.mainButton.layer.borderColor = UIColor.customRed.cgColor
            }
            else {
                self.isFollowing = false
                self.mainButton.backgroundColor = .customRed
                self.mainButton.setTitle("Follow", for: .normal)
            }
        }
    }
    
    
    func setupScrollView() {
        scrollView.backgroundColor = .white
        view.addSubview(scrollView)
        
        scrollView.contentSize.height = view.frame.height * 2 //TODO: this should be dynamic
        scrollView.showsVerticalScrollIndicator = false
        
        //constriants
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: -0.1 * height).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    
    
    func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        
        //if it is not the local user
        if !(navigationController?.viewControllers.count == 1) {
            let backButton = UIBarButtonItem(image: UIImage(named: "backIcon-black"), style: .plain, target: self, action: #selector(goBack))
            navigationController?.navigationBar.tintColor = .black
            navigationItem.setLeftBarButton(backButton, animated: false)
//            isUser = false
        }
        
        else {
            let settings = UIButton(type: .custom)
            settings.setImage(UIImage(named: "settings"), for: .normal)
            settings.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            settings.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(settingToggle)))
            let rightNavItem = UIBarButtonItem(customView: settings)
            navigationItem.setRightBarButton(rightNavItem, animated: false)
        }
    }
    
    
    func setupProfileImage() {
        profileImageView.image = UIImage()
        profileImageView.layer.masksToBounds = true
        profileImageView.backgroundColor = .lightGray
        profileImageView.contentMode = .scaleAspectFill
        scrollView.addSubview(profileImageView)
        
        //constraints
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: height*0.12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: height*0.12).isActive = true
        profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: height*0.125).isActive = true
        profileImageView.layer.cornerRadius = height * 0.06
        
        view.addSubview(backgroundProfileIcon)
        backgroundProfileIcon.translatesAutoresizingMaskIntoConstraints = false
//        backgroundProfileIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0195  * frame.width).isActive = true
//        backgroundProfileIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -0.030  * frame.height).isActive = true
        backgroundProfileIcon.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: width*0.0145).isActive = true
        backgroundProfileIcon.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        backgroundProfileIcon.widthAnchor.constraint(equalToConstant: height*0.17).isActive = true
        backgroundProfileIcon.heightAnchor.constraint(equalToConstant: height*0.17).isActive = true
    }
    
    func setupUsernameLabel() {
        usernameLabel.text = username
        
        //TODO: Add actual font
        usernameLabel.sizeToFit()
        usernameLabel.font = usernameLabel.font.withSize(width/30)
        usernameLabel.textAlignment = .center
        scrollView.addSubview(usernameLabel)
        
        //constraints
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: usernameLabel.font.pointSize * 1.5).isActive = true
        usernameLabel.widthAnchor.constraint(equalToConstant: width*0.6).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
    }
    
    func setupGemLabel() {
        gemLabel.text = "\(numberOfGems) gems"
        gemLabel.sizeToFit()
        gemLabel.textAlignment = .center
        gemLabel.font = gemLabel.font.withSize(width/27)
        scrollView.addSubview(gemLabel)
        
        //constraints
        gemLabel.translatesAutoresizingMaskIntoConstraints = false
        gemLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gemLabel.heightAnchor.constraint(equalToConstant: gemLabel.font.pointSize * 1.5).isActive = true
        gemLabel.widthAnchor.constraint(equalToConstant: width*0.6).isActive = true
        gemLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2).isActive = true
    }
    
    func setupButton() {
        mainButton.backgroundColor = .customRed
        guard let localUser = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey) else { return }
//        isUser = localUser == username
        if isUser {
            mainButton.setTitle("Edit Profile", for: .normal)
            mainButton.addTarget(self, action: #selector(handleEditProfile), for: .touchUpInside)
        }
        else {
            mainButton.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        }
        
        scrollView.addSubview(mainButton)
        mainButton.layer.cornerRadius = 2
        
        //constraints
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        mainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: height/18).isActive = true
        mainButton.widthAnchor.constraint(equalToConstant: width*0.4).isActive = true
        mainButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: height*0.04).isActive = true
    }
    
    func setupAddFolderButton() {
        scrollView.addSubview(addFolderButton)
        addFolderButton.sizeToFit()
        addFolderButton.backgroundColor = UIColor.clear
        addFolderButton.layer.borderWidth = 1
        addFolderButton.layer.borderColor = UIColor.customRed.cgColor
        addFolderButton.clipsToBounds = true
        addFolderButton.text = "Add Folder"
        addFolderButton.textAlignment = .center
        addFolderButton.font = gemLabel.font.withSize(width/27)
        addFolderButton.textColor = .customRed
 
        
        addFolderButton.layer.cornerRadius = 12
        //constraints
        addFolderButton.translatesAutoresizingMaskIntoConstraints = false
        addFolderButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addFolderButton.heightAnchor.constraint(equalToConstant: height * 0.03).isActive = true
        addFolderButton.widthAnchor.constraint(equalToConstant: width*0.3).isActive = true
        addFolderButton.topAnchor.constraint(equalTo: mainButton.bottomAnchor, constant: 15).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleAddFolder))
        addFolderButton.isUserInteractionEnabled = true
        addFolderButton.addGestureRecognizer(tap)
    }
    
    @objc func handleAddFolder(tapGesture: UITapGestureRecognizer) {
        print("working dog")
        var folderName : String = ""
        
        let alert = UIAlertController(title: "Name Your Folder", message: "Assign a title to this folder", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            folderName = textField!.text!.lowercased()
            if folderName != "" {
                let newFolder = Folder(folderName: folderName)
                UserStruct().addFolder(user: self.username, folder: newFolder)
                self.createFolder(folderName: folderName)
            }
            
            
            // TODO add check for duplicate folder names
            //if a folder with that name already exists, then it wont overwrite it
//            if self.folders.contains(where: { (tempFolder) -> Bool in
//                return tempFolder.folderName == folderName
//            }){
//                let alert = UIAlertController(title: "ERROR", message: "A folder with title: \"\(folderName)\" already exits. \n Try a different title.", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
//            else
//            {
                //calling the function to save the folder name to Firebase and create it on the front end
                
//            }
        }))
        
        alert.addAction(UIAlertAction(title:"Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func createFolder(folderName: String){
        let folder = Folder(folderName: folderName)
        UserStruct().addFolder(user: username, folder: folder)
        self.collectionView?.reloadData()
        
        let alert = UIAlertController(title: "Created '\(folderName)' Folder", message: "", preferredStyle: .alert) //Notify the user with an alert
        self.present(alert, animated: true, completion: nil)
        let alertExpiration = DispatchTime.now() + 0.85
        DispatchQueue.main.asyncAfter(deadline: alertExpiration) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func setupSegmentControl() {
        scrollView.addSubview(segmentControl)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(handleSegmentTap), for: .valueChanged)
        
        segmentControl.backgroundColor = .white
        segmentControl.tintColor = .black
        segmentControl.removeBorders()
        //constraints
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: height/18).isActive = true
        segmentControl.widthAnchor.constraint(equalToConstant: width).isActive = true
        segmentControl.topAnchor.constraint(equalTo: addFolderButton.bottomAnchor, constant: height*0.05).isActive = true
    }
    
    func setupSegmentControlBars() {
        let horizontalBarTop = UIView(frame: CGRect.zero)
        let segmentMiddleBar = UIView(frame: CGRect.zero)
        let horizontalBarBottom = UIView(frame: CGRect.zero)
        
        horizontalBarTop.backgroundColor = .lightGray
        scrollView.addSubview(horizontalBarTop)
        
        horizontalBarTop.translatesAutoresizingMaskIntoConstraints = false
        horizontalBarTop.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        horizontalBarTop.heightAnchor.constraint(equalToConstant: 1).isActive = true
        horizontalBarTop.widthAnchor.constraint(equalToConstant: width).isActive = true
        horizontalBarTop.topAnchor.constraint(equalTo: segmentControl.topAnchor, constant: 0).isActive = true
        
        segmentMiddleBar.backgroundColor = .lightGray
        scrollView.addSubview(segmentMiddleBar)
        
        segmentMiddleBar.translatesAutoresizingMaskIntoConstraints = false
        segmentMiddleBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentMiddleBar.heightAnchor.constraint(equalToConstant: height/35).isActive = true
        segmentMiddleBar.widthAnchor.constraint(equalToConstant: 1).isActive = true
        segmentMiddleBar.topAnchor.constraint(equalTo: horizontalBarTop.bottomAnchor, constant: height/75).isActive = true
        
        horizontalBarBottom.backgroundColor = .lightGray
        scrollView.addSubview(horizontalBarBottom)
        
        horizontalBarBottom.translatesAutoresizingMaskIntoConstraints = false
        horizontalBarBottom.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        horizontalBarBottom.heightAnchor.constraint(equalToConstant: 1).isActive = true
        horizontalBarBottom.widthAnchor.constraint(equalToConstant: width).isActive = true
        horizontalBarBottom.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: -1).isActive = true
    }
    
    func setupCollectionViews() {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: viewLayout)
        guard let collectionView = collectionView else { return }
        collectionView.backgroundColor = .lightGray
        collectionView.register(ProfileMainCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        //constraints
        scrollView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: height*2).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: width).isActive = true
        collectionView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 0).isActive = true
        
    }
}
