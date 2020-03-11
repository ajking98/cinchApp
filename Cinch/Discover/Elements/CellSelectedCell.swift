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
var isMuted = true
class CellSelectedCell: UITableViewCell{
    
    //data
    var contentKey = ""
    var handlePresentProfile: ((String) -> Void)?
    var post = Post(isImage: true, numberOfLikes: 0, postOwner: "", likedBy: [], dateCreated: 0, tags: [], link: "")
    
    
    //Views
    var fullScreenImageView = UIImageView(frame: CGRect.zero)
    var playerLayer = AVPlayerLayer()
    let shareIcon = UIImageView(image: UIImage(named: "shareIcon"))
    let heartIcon = UIImageView(image: UIImage(named: "heartIcon"))
    let followUserIcon = UIImageView(image: UIImage(named: "followUserIcon"))
    var profileIcon = UIImageView(frame: CGRect.zero)
    var backgroundProfileIcon = UIImageView(image: UIImage(named: "backgroundRing1"))
    let lowerText = UILabel(frame: CGRect.zero)
    
    //TODO: This should only exist for admin
    let xMark = UIButton(type: .contactAdd)
    let createThumbnailButton = UIButton(type: .roundedRect)
    
    
    func setup(contentKey: String) {
        self.contentKey = contentKey
        
        fetchPost()
        
        print("this is the contentKey", contentKey)
        setupFullScreenImageView()
        setupRightHandView()
        setupLowerText()
        setupxMark()
    }
    
    func fetchPost() {
        ParentPostStruct().readPost(contentKey: contentKey) { (post) in
            print("we are going here: ", post)
            self.post = post
            self.fetchContent()
            print("finishing pretty hard")
        }
    }
    
    func setupxMark() {
        xMark.addTarget(self, action: #selector(handleRemoved), for: .touchUpInside)
        xMark.frame = CGRect(x: 200, y: 200, width: 50, height: 50)
        xMark.backgroundColor = .red
        xMark.titleLabel?.text = "Delete"
        xMark.isHidden = !isAdmin //TODO remove this to be able to delete posts
        addSubview(xMark)
        
        //createThumbnail Button
        createThumbnailButton.addTarget(self, action: #selector(handleAddThumbnail), for: .touchUpInside)
        createThumbnailButton.frame = CGRect(x: 275, y: 200, width: 50, height: 50)
        createThumbnailButton.backgroundColor = .green
        createThumbnailButton.isHidden = !isAdmin
        createThumbnailButton.titleLabel!.text = "Thumbnail"
        addSubview(createThumbnailButton)
    }
    
    @objc func handleAddThumbnail() {
        SuperFunctions().createThumbnail(contentKey: contentKey)
    }
    
    @objc func handleRemoved() {
        print("this is something coll:", self.post.contentKey)
        print("this is the post: ", self.post.toString())
        
        SuperFunctions().permanentlyDeletePost(post: self.post)
    }
    
    override func prepareForReuse() {
        playerLayer.player?.isMuted = true
        playerLayer = AVPlayerLayer()
        profileIcon.image = UIImage()
        fullScreenImageView = UIImageView()
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
    
    func fetchContent() {
        guard let link = post.link else { return }
        let author = post.postOwner ?? ""
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
        
        UserStruct().readProfilePic(user: author) { (profilePic) in
            self.profileIcon.sd_setImage(with: URL(string: profilePic), placeholderImage: UIImage(), completed: nil)
        }
        
        self.lowerText.text = ""
        for tag in post.tags ?? [] {
            self.lowerText.text? += "#\(tag) "
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
        shareIcon.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -0.05  * frame.width).isActive = true
//        shareIcon.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        shareIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0.05  * frame.height).isActive = true
        shareIcon.isUserInteractionEnabled = true
        shareIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShare)))
        
        //heart icon
        addSubview(heartIcon)
        heartIcon.translatesAutoresizingMaskIntoConstraints = false
        heartIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        heartIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -0.05  * frame.height).isActive = true
        heartIcon.isUserInteractionEnabled = true
        heartIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleHearted)))
        
        //profile icon
        profileIcon.backgroundColor = .lightGray
        
        addSubview(profileIcon)
        profileIcon.translatesAutoresizingMaskIntoConstraints = false
        profileIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.05  * frame.width).isActive = true
        profileIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -0.05  * frame.height).isActive = true
        profileIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        profileIcon.layer.cornerRadius = 20
        profileIcon.clipsToBounds = true
        profileIcon.isUserInteractionEnabled = true
        profileIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfilePicPressed)))
        
        addSubview(backgroundProfileIcon)
        backgroundProfileIcon.translatesAutoresizingMaskIntoConstraints = false
//        backgroundProfileIcon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0195  * frame.width).isActive = true
//        backgroundProfileIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -0.030  * frame.height).isActive = true
        backgroundProfileIcon.centerYAnchor.constraint(equalTo: profileIcon.centerYAnchor, constant: 3).isActive = true
        backgroundProfileIcon.centerXAnchor.constraint(equalTo: profileIcon.centerXAnchor).isActive = true
        backgroundProfileIcon.widthAnchor.constraint(equalToConstant: 66).isActive = true
        backgroundProfileIcon.heightAnchor.constraint(equalToConstant: 66).isActive = true
        
//        //follow user icon
//        addSubview(followUserIcon)
//        followUserIcon.translatesAutoresizingMaskIntoConstraints = false
//        followUserIcon.centerYAnchor.constraint(equalTo: profileIcon.bottomAnchor).isActive = true
//        followUserIcon.centerXAnchor.constraint(equalTo: profileIcon.centerXAnchor).isActive = true
        }
    
    
    ///Allows user to save content to device or export to another app
    @objc func handleShare() {
        guard let link = post.link else { return }
        var status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (requestedStatus) in
                status = requestedStatus
                DispatchQueue.main.async {
                    if checkIfVideo(link) {
                        self.handleShareVideo()
                    }
                    else {
                    let vc = UIActivityViewController(activityItems: [self.fullScreenImageView.image], applicationActivities: [])
                    self.parentViewController?.present(vc, animated: true, completion: nil)
                        
                    }
                }
            }
        }
        if status == .authorized {
            if checkIfVideo(link) {
                handleShareVideo()
            }
            else {
            let vc = UIActivityViewController(activityItems: [self.fullScreenImageView.image], applicationActivities: [])
            self.parentViewController?.present(vc, animated: true, completion: nil)
                
            }
        }
    }
    
    func handleShareVideo() {
        guard let link = post.link else { return }
        guard let url = URL(string: link) else { return }
        DispatchQueue.global(qos: .background).async {
            if let urlData = NSData(contentsOf: url){
              let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                 let filePath="\(documentsPath)/tempFile.mov"
                 DispatchQueue.main.async {
                   urlData.write(toFile: filePath, atomically: true)

                   //Hide activity indicator

                   let activityVC = UIActivityViewController(activityItems: [NSURL(fileURLWithPath: filePath)], applicationActivities: nil)
                   activityVC.excludedActivityTypes = [.addToReadingList, .assignToContact]
                    self.parentViewController?.present(activityVC, animated: true, completion: nil)
                 }
             }
         }
    }
    
    @objc func handleHearted() {
        //todo: add link to the folder
        guard let localUser = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey) else { return }

        guard let link = post.link else { return }
        FolderStruct().addContent(user: localUser, folderName: "Likes", contentKey: contentKey, link: link)
        let alert = UIAlertController(title: "Added to \"Likes\" Folder", message: "", preferredStyle: .alert) //Notify the user with an alert
        parentViewController?.present(alert, animated: true, completion: {
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert)))
        })
        
        let alertExpiration = DispatchTime.now() + 0.85
        DispatchQueue.main.asyncAfter(deadline: alertExpiration) {
        alert.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func dismissAlert() {
        parentViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleProfilePicPressed() {
        //push using navigation
        guard let username = post.postOwner else { return }
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
        lowerText.bottomAnchor.constraint(equalTo: profileIcon.topAnchor, constant: -0.02 * frame.height).isActive = true
        lowerText.heightAnchor.constraint(equalToConstant: 0.15 * frame.height).isActive = true
    }
    
}
