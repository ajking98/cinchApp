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
    
    var profileName = "Ahmed Gedi"
    var username = "@ahmedgedi"
    
    var profileImageView = UIImageView(frame: CGRect.zero)
    var usernameLabel = UILabel(frame: CGRect.zero)
    var gemLabel = UILabel(frame: CGRect.zero)
    var numberOfGems = 0
    var isUser = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupNavigationBar()
        setupProfileImage()
        setupUsernameLabel()
        setupGemLabel()
    }
    
    //sets the data - width, height, profileName, username, isUser etc.
    func setupData() {
        height = view.frame.height
        width = view.frame.width
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
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
    
    
    
    @objc func settingToggle() {
        print("Toggled Settings")
    }
    

}
