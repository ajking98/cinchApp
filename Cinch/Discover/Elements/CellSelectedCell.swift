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
    var contentKey = ""
    var handlePresentProfile: ((String) -> Void)?
    var post = Post(isImage: true, numberOfLikes: 0, postOwner: "", likedBy: [], dateCreated: 0, tags: [], link: "")
    
    //Views
    var fullScreenImageView = UIImageView(frame: CGRect.zero)
    var playerLayer = AVPlayerLayer()
    var player = AVQueuePlayer()
    let shareIcon = UIImageView(image: UIImage(named: "shareIcon"))
    let heartIcon = UIImageView(image: UIImage(named: "heartIcon"))
    let copyIcon = UIImageView(image: UIImage(named: "CopyLink"))
    let followUserIcon = UIImageView(image: UIImage(named: "followUserIcon"))
    var profileIcon = UIImageView(frame: CGRect.zero)
    var backgroundProfileIcon = UIImageView(image: UIImage(named: "backgroundRing1"))
    let lowerText = UILabel(frame: CGRect.zero)
    var videoLooper: AVPlayerLooper?
    var alert = UIAlertController(title: "", message: "", preferredStyle: .alert) //Notify the user with an alert
    
    //TODO: This should only exist for admin
    let removeMedia = UIButton()
    var createThumbnailButton = UIButton()
    var isHearted = false
    
    
    func setup(contentKey: String) {
        self.contentKey = contentKey
        
        fetchPost()
        
        setupFullScreenImageView()
        setupRightHandView()
        setupLowerText()
        setupxMark()
        
        FolderStruct()
    }
    
    func fetchPost() {
        ParentPostStruct().readPost(contentKey: contentKey) { (post) in
            self.post = post
            self.fetchContent()
        }
        
        guard let username = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey) else { return }
        
        FolderStruct().isInFolder(user: username, folderName: "Hearted", contentKey: contentKey) { (isInFolder) in
            if(isInFolder) {
                self.heartIcon.image = UIImage(named: "heartIcon-Selected")
                self.isHearted = true
            }
            else {
                self.heartIcon.image = UIImage(named: "heartIcon")
            }
        }
    }
    
    func setupxMark() {
        removeMedia.addTarget(self, action: #selector(handleRemoved), for: .touchUpInside)
        removeMedia.frame = CGRect(x: 50, y: 200, width: 100, height: 50)
        removeMedia.backgroundColor = .red
        removeMedia.setTitle("Delete", for: .normal)
        removeMedia.isHidden = !isAdmin //TODO remove this to be able to delete posts
        addSubview(removeMedia)
        
        
        //createThumbnail Button
        createThumbnailButton.addTarget(self, action: #selector(handleAddThumbnail), for: .touchUpInside)
        createThumbnailButton.frame = CGRect(x: 200, y: 200, width: 150, height: 50)
        createThumbnailButton.backgroundColor = .green
        createThumbnailButton.isHidden = !isAdmin
        createThumbnailButton.setTitle("Create Thumbnail", for: .normal)
        addSubview(createThumbnailButton)
    }
    
    @objc func handleAddThumbnail() {
        SuperFunctions().createThumbnail(contentKey: contentKey)
    }
    
    @objc func handleRemoved() {
        SuperFunctions().permanentlyDeletePost(post: self.post)
    }
    
    func fetchContent() {
        guard let link = post.link else { return }
        let author = post.postOwner ?? ""
        
        
        //Tap Gesture
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleHearted))
        doubleTap.numberOfTapsRequired = 2
        fullScreenImageView.addGestureRecognizer(doubleTap)
        fullScreenImageView.isUserInteractionEnabled = true
        let longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleCopy))
        fullScreenImageView.addGestureRecognizer(longGestureRecognizer)
        
        
        if checkIfVideo(link) {
            guard let link = URL(string: link) else { return }
            
            
            //looping
            let asset = AVAsset(url: link)
            let item = AVPlayerItem(asset: asset)
            player = AVQueuePlayer(playerItem: item)
            
            
            videoLooper = AVPlayerLooper(player: player, templateItem: item)
            
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.player?.play()
            fullScreenImageView.layer.addSublayer(playerLayer)
            playerLayer.frame = fullScreenImageView.layer.bounds
            
            playerLayer.videoGravity = .resizeAspect
            playerLayer.player?.isMuted = isMuted
            let audioControlTap = UITapGestureRecognizer(target: self, action: #selector(handleImageViewTapped))
            audioControlTap.numberOfTapsRequired = 1
            fullScreenImageView.addGestureRecognizer(audioControlTap)
            audioControlTap.require(toFail: doubleTap)
            audioControlTap.delaysTouchesBegan = true
            doubleTap.delaysTouchesBegan = true
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
    
    @objc func playerDidFinish() {
        print("this is done playing")
        self.player.seek(to: CMTime.zero)
        self.player.play()
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
        
        //Zoom in capabilities
        let imageScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        imageScrollView.delegate = self
        imageScrollView.minimumZoomScale = 1
        imageScrollView.maximumZoomScale = 5
        imageScrollView.backgroundColor = .black
        
        addSubview(imageScrollView)
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        imageScrollView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        imageScrollView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        
//        imageScrollView
        imageScrollView.addSubview(fullScreenImageView)
        fullScreenImageView.frame.size.width = frame.width
        fullScreenImageView.frame.size.height = frame.height
        fullScreenImageView.center.y = frame.height / 2
        print("this is teh size:", fullScreenImageView.frame)
        print("frame size for imageScrollView:", imageScrollView.frame)
        
        //Main Content
        fullScreenImageView.contentMode = .scaleAspectFit
        
    }
    
    
    func setupRightHandView() {
        //share icon
        addSubview(shareIcon)
        shareIcon.translatesAutoresizingMaskIntoConstraints = false
        shareIcon.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -0.05  * frame.width).isActive = true
        shareIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0.05  * frame.height).isActive = true
        shareIcon.isUserInteractionEnabled = true
        shareIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShare)))
        
        //Copy Link Icon
        addSubview(copyIcon)
        copyIcon.translatesAutoresizingMaskIntoConstraints = false
        copyIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        copyIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        copyIcon.centerYAnchor.constraint(equalTo: shareIcon.centerYAnchor, constant: 0).isActive = true
        copyIcon.rightAnchor.constraint(equalTo: self.shareIcon.leftAnchor, constant: -0.1 * frame.width).isActive = true
        copyIcon.clipsToBounds = true
        copyIcon.layer.masksToBounds = true
        copyIcon.isUserInteractionEnabled = true
        copyIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCopy)))
        
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
    

    @objc func handleCopy(_ gesture: UIGestureRecognizer? = nil) {
        if let _ = gesture as? UILongPressGestureRecognizer {
            guard gesture?.state == .began else { return }
        }
        
        //Copy to clipboard
        guard let link = post.link else { return }
        
        
        print("copying")
        alert.title = "Copied!"
        parentViewController?.present(alert, animated: true, completion: {
            self.alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert)))
        })
        
        if checkIfVideo(link) {
            guard let clipBoardURL = URL(string: post.link ?? "") else { return }
            guard let clipBoardData = try? Data(contentsOf: clipBoardURL) else { return }
            
            UIPasteboard.general.setData(clipBoardData, forPasteboardType: "public.mpeg-4")
        }
        else {
        UIPasteboard.general.image = fullScreenImageView.image
        }
        
        let alertExpiration = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: alertExpiration) {
            self.alert.dismiss(animated: true, completion: nil)
        }
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    @objc func handleHearted() {
        
        
        //adds link to the folder
        guard let localUser = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey) else { return }
        
        guard let link = post.link else { return }

        parentViewController?.present(alert, animated: true, completion: {
            self.alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert)))
        })
        
        if isHearted {
            FolderStruct().deleteContent(user: localUser, folderName: "Hearted", contentKey: contentKey)
            PostStruct().decrementNumberOfLikes(contentKey: contentKey)
            alert.title = "Removed From Favorites"
        }
        else {
            FolderStruct().addContent(user: localUser, folderName: "Hearted", contentKey: contentKey, link: link)
            PostStruct().incrementNumberOfLikes(contentKey: contentKey)
            alert.title = "Added To Favorites!"
        }
        
        isHearted = !isHearted
        let alertExpiration = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: alertExpiration) {
            self.alert.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func dismissAlert() {
        alert.dismiss(animated: true, completion: nil)
        alert.removeFromParent()
        print("this is dismissing")
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
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.fullScreenImageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("we ended zooming")
        scrollView.setZoomScale(1, animated: true)
    }
    
}
