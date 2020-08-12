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
    var numberOfGems = 0
    var stackView = ProfileStackView(frame: CGRect.zero)
    var mainButton = UIButton(frame: CGRect.zero) //this is the button that can either be "edit profile" or "follow/unfollow"
    var segmentControl = UISegmentedControl(items: ["Uploaded", "Favorites"])
    var collectionView: UICollectionView?
    let followNav = UIButton(type: .custom)
    
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
        if isUser {
            print(isUser)
        }
        
        setupSegmentControl()
        setupSegmentControlBars()
        setupCollectionViews()
    }
    
    
    //TODO: Take a look at this
    func fetchData() {
        let localUser = String(UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!)
        print("these are the two usernames:", username, " VS ", localUser)
        
        isUser = checkIfLocalUser(username: username)
        username = isUser ? localUser : username
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = .white
//        collectionView?.reloadData()
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
        if isUser { return }
        mainButton.setTitle("Follow", for: .normal)
        guard let localUser = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey) else { return }
        UserStruct().readFollowing(user: localUser) { (users) in
            if users.contains(self.username) {
                self.isFollowing = true
                self.mainButton.layer.borderWidth = 1.7
                self.mainButton.backgroundColor = .white
                self.mainButton.setTitle("Unfollow", for: .normal)
                self.mainButton.setTitleColor(.darkBlue, for: .normal)
                self.mainButton.layer.borderColor = UIColor.darkBlue.cgColor
            }
            else {
                self.isFollowing = false
                self.mainButton.backgroundColor = .darkBlue
                self.mainButton.setTitle("Follow", for: .normal)
            }
        }
    }
    
    
    func setupScrollView() {
        scrollView.backgroundColor = .white
        view.addSubview(scrollView)
        
        scrollView.contentSize.height = view.frame.height * 1 //TODO: this should be dynamic
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
            let backButton = UIBarButtonItem(image: UIImage(named: "backIcon-black"), style: .plain, target: self, action: #selector(goBack))
            navigationController?.navigationBar.tintColor = .black
            navigationItem.setLeftBarButton(backButton, animated: false)

            
//            followNav.setTitle("Follow", for: .normal)
//            followNav.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//            followNav.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFollowUser)))
//            let rightNavItem = UIBarButtonItem(customView: followNav)
//            navigationItem.setRightBarButton(rightNavItem, animated: false)
//            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Follow", style: .plain, target: self, action: #selector(handleFollowUser))
//            navigationItem.rightBarButtonItem?.tintColor = .customRed
        }
        
        else {
            let settings = UIButton(type: .custom)
            settings.setImage(UIImage(named: "settings"), for: .normal)
            settings.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
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
        mainButton.backgroundColor = .darkBlue
        
        print("this is the status:", username, isUser)
        if isUser {
            print("this should be setting")
            mainButton.setTitle("Edit Profile", for: .normal)
            mainButton.addTarget(self, action: #selector(handleEditProfile), for: .touchUpInside)
        } else {
            mainButton.setTitle("Follow", for: .normal)
            mainButton.addTarget(self, action: #selector(handleFollowUser), for: .touchUpInside)
        }
        
        scrollView.addSubview(mainButton)
        mainButton.layer.cornerRadius = 3
        
        //constraints
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        mainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: height/18).isActive = true
        mainButton.widthAnchor.constraint(equalToConstant: width*0.4).isActive = true
        mainButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: height*0.04).isActive = true
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
        segmentControl.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: height*0.17).isActive = true
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
        collectionView.heightAnchor.constraint(equalToConstant: height*20).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: width).isActive = true
        collectionView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 0).isActive = true
        
    }
    
    ///resets the value conentSize of the scrollview after the memes are fetched
    func resetSize(height: CGFloat){
        scrollView.contentSize.height = height
    }
}
