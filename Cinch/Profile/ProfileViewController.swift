//
//  ProfileViewController.swift
/*
    1. Design the nav bar
    2. Build the profile image
 */
//  Created by Alsahlani, Yassin K on 1/28/20.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //data
    var height: CGFloat = 0
    var width: CGFloat = 0
    var isUser = true
    
    var profileName = "Ahmed Gedi"
    var username = "@ahmedgedi"
    var followers = 0
    var followings = 0
    var likes = 0
    var isFollowing = false
    var segmentControl = UISegmentedControl(items: ["somethign", "else"])
    
    //elements
    var profileImageView = UIImageView(frame: CGRect.zero)
    var usernameLabel = UILabel(frame: CGRect.zero)
    var gemLabel = UILabel(frame: CGRect.zero)
    var numberOfGems = 0
    var stackView = ProfileStackView(frame: CGRect.zero)
    var mainButton = UIButton(frame: CGRect.zero) //this is the button that can either be "edit profile" or "follow/unfollow"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupNavigationBar()
        setupProfileImage()
        setupUsernameLabel()
        setupGemLabel()
        stackView.setup(followings: followings, followers: followers, Likes: likes, view: view)
        setupButton()
    }
    
    //sets the data - width, height, profileName, username, isUser, isFollowing etc.
    func setupData() {
        height = view.frame.height
        width = view.frame.width
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        title = profileName
        
        //if it is not the local user
        if !isUser {
            //todo
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
        profileImageView.image = UIImage(named: "B")
        profileImageView.layer.masksToBounds = true
        profileImageView.backgroundColor = .lightGray
        profileImageView.contentMode = .scaleAspectFill
        view.addSubview(profileImageView)
        
        //constraints
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: height*0.12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: height*0.12).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: height/9).isActive = true
        profileImageView.layer.cornerRadius = height * 0.06
    }
    
    func setupUsernameLabel() {
        usernameLabel.text = username
        
        //TODO: Add actual font
        usernameLabel.sizeToFit()
        usernameLabel.font = usernameLabel.font.withSize(width/30)
        usernameLabel.textAlignment = .center
        view.addSubview(usernameLabel)
        
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
        view.addSubview(gemLabel)
        
        //constraints
        gemLabel.translatesAutoresizingMaskIntoConstraints = false
        gemLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gemLabel.heightAnchor.constraint(equalToConstant: gemLabel.font.pointSize * 1.5).isActive = true
        gemLabel.widthAnchor.constraint(equalToConstant: width*0.6).isActive = true
        gemLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2).isActive = true
    }
    
    func setupButton() {
        mainButton.backgroundColor = .customRed
        
        if isUser {
            mainButton.setTitle("Edit Profile", for: .normal)
            mainButton.addTarget(self, action: #selector(handleEditProfile), for: .touchUpInside)
        }
        else {
            if isFollowing {
                mainButton.layer.borderWidth = 1.7
                mainButton.backgroundColor = .white
                mainButton.setTitle("Unfollow", for: .normal)
                mainButton.setTitleColor(.customRed, for: .normal)
                mainButton.layer.borderColor = UIColor.gray.cgColor //Maybe make this customRed as well
            }
            else{
                mainButton.setTitle("Follow", for: .normal)
            }
            mainButton.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        }
        
        view.addSubview(mainButton)
        mainButton.layer.cornerRadius = 2
        
        //constraints
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        mainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: height/18).isActive = true
        mainButton.widthAnchor.constraint(equalToConstant: width*0.4).isActive = true
        mainButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20).isActive = true
    }
    
    
    func setupSegmentControl() {
        view.addSubview(segmentControl)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(handleSegmentTap), for: .valueChanged)
        
        segmentControl.backgroundColor = .green
        segmentControl.tintColor = .black
//        segmentControl.remove
        
        //constraints
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: height/18).isActive = true
        segmentControl.widthAnchor.constraint(equalToConstant: width).isActive = true
        segmentControl.topAnchor.constraint(equalTo: mainButton.bottomAnchor, constant: height/25).isActive = true
    }
    
    func setupSegmentControlBars() {
        
    }
    
    
    
    @objc func settingToggle() {
        print("Toggled Settings")
    }
    
    
    @objc func handleEditProfile(){
        print("working")
    }
    
    @objc func handleFollow(){
        if isFollowing {
            print("UnFollowing")
        }
        else{
            print("Following")
        }
    }
    
    @objc func handleSegmentTap() {
        print("we are switching")
    }
    
    
    

}
