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
    var usernameLabel = UILabel(frame: CGRect.zero)
    var gemLabel = UILabel(frame: CGRect.zero)
    var numberOfGems = 0
    var stackView = ProfileStackView(frame: CGRect.zero)
    var mainButton = UIButton(frame: CGRect.zero) //this is the button that can either be "edit profile" or "follow/unfollow"
    var segmentControl = UISegmentedControl(items: [UIImage(named: "like"), UIImage(named: "profileGems")])
    var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchData()
        setupData()
        setupScrollView()
        setupNavigationBar()
        setupProfileImage()
        setupUsernameLabel()
        setupGemLabel()
        stackView.setup(followings: followings, followers: followers, Gems: gems, view: view, scrollView: scrollView)
        setupButton()
        setupSegmentControl()
        setupSegmentControlBars()
        setupCollectionViews()
    }
    
    func fetchData() {
        let localUser = String(UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!)
        print("these are the two usernames:", username, " VS ", localUser)
        if username == ""  || username == localUser { //checks if the user is looking at their profile or someone else's
            username = localUser
        } else {
            UserStruct().readFollowing(user: localUser) { (followers) in
                if followers.values.contains(self.username) {
                    //make the button disabled and greyed out
                    print("hey")
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    //sets the data - width, height, profileName, username, isUser, isFollowing etc.
    func setupData() {
        height = view.frame.height
        width = view.frame.width
        fetchProfilePic()
        fetchTitle()
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
        profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: height/9).isActive = true
        profileImageView.layer.cornerRadius = height * 0.06
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
        
        scrollView.addSubview(mainButton)
        mainButton.layer.cornerRadius = 2
        
        //constraints
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        mainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: height/18).isActive = true
        mainButton.widthAnchor.constraint(equalToConstant: width*0.4).isActive = true
        mainButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20).isActive = true
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
        segmentControl.topAnchor.constraint(equalTo: mainButton.bottomAnchor, constant: height/50).isActive = true
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
