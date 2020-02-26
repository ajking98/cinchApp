//
//  CellSelectedController.swift
//  Cinch
/*
    1. Add fullscreen image
    2. Add Back button
    3. Add right hand side
    4. Add hashtags
    5. Put it in a tableView
*/
//  Created by Alsahlani, Yassin K on 1/27/20.

import UIKit
import AVKit
import Photos

///holds the value for whether the cell is muted or not
var isMuted = false
class CellSelectedCell: UITableViewCell{
    
    //data
    var link = ""
    var username = ""
    var handlePresentProfile: ((String) -> Void)?
    var post = Post(isImage: true, numberOfLikes: 0, postOwner: "", likedBy: [], dateCreated: 0, tags: [], link: "")
    
    var fullScreenImageView = UIImageView(frame: CGRect.zero)
    var playerLayer = AVPlayerLayer()
    let shareIcon = UIImageView(image: UIImage(named: "shareIcon"))
    let heartIcon = UIImageView(image: UIImage(named: "heartIcon"))
    let followUserIcon = UIImageView(image: UIImage(named: "followUserIcon"))
    var profileIcon = UIImageView(frame: CGRect.zero)
    let lowerText = UILabel(frame: CGRect.zero)
    
    var outputVolumeObserve: NSKeyValueObservation?
    let audioSession = AVAudioSession.sharedInstance()
    
    
    //TODO: This should only exist for admin
    let xMark = UIButton(type: .contactAdd)
    let createThumbnailButton = UIButton(type: .roundedRect)
    
    
    func setup(link: String) {
        post.link = link
        
        PostStruct().readTags(post: link) { (tags) in
            self.post.tags = tags
        }
        
        
        
        self.link = link
        username = "nil"
        fetchContent()
        setupFullScreenImageView()
        setupRightHandView()
        setupLowerText()
        setupxMark()
        listenVolumeButton()
    }
    
    func setupxMark() {
        xMark.addTarget(self, action: #selector(handleRemoved), for: .touchUpInside)
        xMark.frame = CGRect(x: 200, y: 200, width: 50, height: 50)
        xMark.backgroundColor = .green
        xMark.isHidden = false //TODO remove this to be able to delete posts
        addSubview(xMark)
        
        //createThumbnail Button
        createThumbnailButton.addTarget(self, action: #selector(handleAddThumbnail), for: .touchUpInside)
        createThumbnailButton.frame = CGRect(x: 275, y: 200, width: 50, height: 50)
        createThumbnailButton.backgroundColor = .yellow
        createThumbnailButton.isHidden = false
        addSubview(createThumbnailButton)
    }
    
    @objc func handleAddThumbnail() {
//        imageView?.frame = frame
//        imageView?.backgroundColor = .brown
//        print("this is adding a thumbnail", imageView)
//        print("backgroun color: ", imageView?.backgroundColor)
//        imageView?.image = UIImage(named: "t6")
        SuperFunctions().createThumbnail(link: self.link)
    }
    
    @objc func handleRemoved() {
        print("this is the post: ", self.post.toString())
        SuperFunctions().permanentlyDeletePost(post: self.post)
    }
    
    override func prepareForReuse() {
        username = "nil"
        playerLayer.player?.isMuted = true
        playerLayer = AVPlayerLayer()
        profileIcon.image = UIImage()
        fullScreenImageView = UIImageView()
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
    
    func fetchContent() {
        
        if checkIfVideo(link) {
            guard let link = URL(string: link) else { return }
            playerLayer = fullScreenImageView.loadVideo(link, size: frame.size)
            playerLayer.videoGravity = .resizeAspect
            playerLayer.player?.isMuted = isMuted
            fullScreenImageView.isUserInteractionEnabled = true
            fullScreenImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageViewTapped)))
        }
        else {
            fullScreenImageView.sd_setImage(with: URL(string: link), placeholderImage: UIImage(), completed: nil)
        }
        PostStruct().readPostOwner(post: link) { (author) in
            self.username = author
            
            UserStruct().readProfilePic(user: author) { (profilePic) in
                self.profileIcon.sd_setImage(with: URL(string: profilePic), placeholderImage: UIImage(), completed: nil)
            }
        }
        PostStruct().readTags(post: link) { (tags) in
            self.lowerText.text = ""
            for tag in tags {
                self.lowerText.text? += "#\(tag) "
            }
        }
    }
    
    @objc func handleImageViewTapped() {
        if AVAudioSession.sharedInstance().category == .soloAmbient {
            print("this is in silent mode")
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            }
            catch {
                print("The device cannot play audio")
            }
        }
        else {
            playerLayer.player?.isMuted.toggle()
            isMuted.toggle()
        }
    }
    
    func listenVolumeButton() {
       do {
        try audioSession.setActive(true)
       } catch {
        print("some error")
       }
       audioSession.addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
          if keyPath == "outputVolume" {
            playerLayer.player?.isMuted = false
            isMuted = false
              do {
                  try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
              }
              catch {
                  print("The device cannot play audio")
              }
        }
    }
    
    //full screen imageview
    func setupFullScreenImageView(){
        backgroundColor = .black
        addSubview(fullScreenImageView)
        
        //constraints
        fullScreenImageView.translatesAutoresizingMaskIntoConstraints = false
        fullScreenImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        fullScreenImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        fullScreenImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        fullScreenImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        //Main Content
        fullScreenImageView.contentMode = .scaleAspectFit
        
    }
    
    
    func setupRightHandView() {
        //share icon
        addSubview(shareIcon)
        shareIcon.translatesAutoresizingMaskIntoConstraints = false
        shareIcon.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        shareIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0.31 * frame.height).isActive = true
        shareIcon.isUserInteractionEnabled = true
        shareIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShare)))
        
        //heart icon
        addSubview(heartIcon)
        heartIcon.translatesAutoresizingMaskIntoConstraints = false
        heartIcon.centerXAnchor.constraint(equalTo: shareIcon.centerXAnchor).isActive = true
        heartIcon.bottomAnchor.constraint(equalTo: shareIcon.topAnchor, constant: -20).isActive = true
        heartIcon.isUserInteractionEnabled = true
        heartIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleHearted)))
        
        
        //profile icon
        profileIcon.backgroundColor = .lightGray
        
        addSubview(profileIcon)
        profileIcon.translatesAutoresizingMaskIntoConstraints = false
        profileIcon.centerXAnchor.constraint(equalTo: heartIcon.centerXAnchor).isActive = true
        profileIcon.bottomAnchor.constraint(equalTo: heartIcon.topAnchor, constant: -25).isActive = true
        profileIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        profileIcon.layer.cornerRadius = 20
        profileIcon.clipsToBounds = true
        profileIcon.isUserInteractionEnabled = true
        profileIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfilePicPressed)))
        
        
        //follow user icon
        addSubview(followUserIcon)
        followUserIcon.translatesAutoresizingMaskIntoConstraints = false
        followUserIcon.centerYAnchor.constraint(equalTo: profileIcon.bottomAnchor).isActive = true
        followUserIcon.centerXAnchor.constraint(equalTo: profileIcon.centerXAnchor).isActive = true
    }
    
    
    ///Allows user to save content to device or export to another app
    @objc func handleShare() {
        var status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (requestedStatus) in
                status = requestedStatus
                DispatchQueue.main.async {
                    let vc = UIActivityViewController(activityItems: [self.fullScreenImageView.image], applicationActivities: [])
                    self.parentViewController?.present(vc, animated: true, completion: nil)
                }
            }
        }
        if status == .authorized {
            let vc = UIActivityViewController(activityItems: [self.fullScreenImageView.image], applicationActivities: [])
            self.parentViewController?.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func handleHearted() {
        //todo: add link to the folder
        guard let localUser = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey) else { return }
        FolderStruct().addContent(user: localUser, folderName: "Hearted", link: link)
        let alert = UIAlertController(title: "Added to \"Hearted\" Folder", message: "", preferredStyle: .alert) //Notify the user with an alert
        parentViewController?.present(alert, animated: true, completion: nil)
        let alertExpiration = DispatchTime.now() + 0.85
        DispatchQueue.main.asyncAfter(deadline: alertExpiration) {
        alert.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleProfilePicPressed() {
        //push using navigation
        guard let handlePresentProfile = handlePresentProfile else { return }
        handlePresentProfile(username)
        
    }
    
    func setupLowerText() {
        lowerText.textColor = .lightGray
        addSubview(lowerText)
        lowerText.font.withSize(13)
        lowerText.numberOfLines = 0
        lowerText.translatesAutoresizingMaskIntoConstraints = false
        lowerText.leftAnchor.constraint(equalTo: leftAnchor, constant: 17.5).isActive = true
        lowerText.widthAnchor.constraint(equalToConstant: 0.8 * frame.width).isActive = true
        lowerText.topAnchor.constraint(equalTo: bottomAnchor, constant: -0.2 * frame.height).isActive = true
        lowerText.heightAnchor.constraint(equalToConstant: 0.15 * frame.height).isActive = true
    }
    
}
