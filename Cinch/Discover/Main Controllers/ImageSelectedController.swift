//
//  ImageSelectedController.swift
//  Cinch
//
//  Created by Ahmed Gedi on 7/5/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import AVKit
import SDWebImage
import XLActionController

class ImageSelectedController: UIViewController {
    
    var post : Post! //post object also has the link to the post 
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lowerView: UIView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var labels: UIView!
    var menuOptions = MenuOptions()
    var shareButton = ShareButton()
    var likesView = UILabel(frame: CGRect.zero)
    var authorView = UILabel(frame: CGRect.zero)
    var isFromDiscover = true
    
    //player variables
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    
    override func viewDidLoad() {
        print("okay we are reaching")
        super.viewDidLoad()
        
        setUp()
        
        setUpScrollView()
        
        guard isFromDiscover else {
            lowerView.frame.size = CGSize(width: 0, height: 0)
            lowerView.isHidden = true
            scrollView.center.y += 500
            postImage.center.y += 120
            return
        }
        
        labels.addGestureRecognizer((navigationController?.interactivePopGestureRecognizer)!)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if playerLayer != nil {
            player.isMuted = true
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        postImage.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor)
        postImage.centerYAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerYAnchor)
        return postImage
    }
    
    
    func setUpScrollView() {
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 20.0
//        scrollView.delegate = self //- it is set on the storyboard.
        scrollView.isUserInteractionEnabled = true
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMute)))
    }
    
    @objc func handleMute() {
        if playerLayer != nil {
            player.isMuted = !player.isMuted
        }
    }
    
    func setUp() {
        //placing image
        guard let link = post.link else {
            return
        }
        let url = URL(string: link)
        if link.contains(".mp4") {
            
            playerItem = AVPlayerItem(url: url!)
            player = AVPlayer(playerItem: playerItem)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resize
            postImage.layer.addSublayer(playerLayer)
            playerLayer.frame = postImage.bounds
            player.play()
            player.isMuted = true
            loopVideo(videoPlayer: player)
            
            postImage!.contentMode = .scaleAspectFill
            postImage!.clipsToBounds = true
        }
        else {
            postImage.sd_setImage(with: url, placeholderImage: UIImage(named: "n2"), completed: nil)
            
        }
        
        let centerY = (labels.frame.height / 2) - 5
        
        //Menu
        menuOptions.center = CGPoint(x: labels.frame.width - 30, y: centerY)
        menuOptions.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(postActivityController)))
        
        //share Button
        shareButton.center = CGPoint(x: 30, y: centerY)
        shareButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTransfer)))
        
        //gestures for authorView
        authorView.isUserInteractionEnabled = true
        authorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAuthorPressed)))
        
        //Sizing
        likesView.frame.size = CGSize(width: 70, height: 20)
        authorView.frame.size = CGSize(width: (labels.frame.width / 2) - 10, height: 20)
        
        //positioning
        likesView.center = CGPoint(x: 90, y: centerY)
        authorView.center = CGPoint(x: labels.frame.width / 2, y: centerY)
        authorView.textAlignment = .center
        
        //adding text TODO get rid of this later
        likesView.text = String(post.numberOfLikes!)
        authorView.text = post.postOwner
        
        //add subviews
        labels.addSubview(menuOptions)
//        labels.addSubview(likesView)
        labels.addSubview(authorView)
        labels.addSubview(shareButton)
        
        lowerView.frame.size.width = view.frame.width
        lowerView.center.x = view.center.x
        
        
        lowerView.isUserInteractionEnabled = true
    }
    
    @objc func handleAuthorPressed() {
        let vc = UIStoryboard(name: "ProfilePage", bundle: nil).instantiateViewController(withIdentifier: "profilePage") as! ProfilePageViewController
        let author = authorView.text
        UserDefaults.standard.setValue(author, forKey: defaultsKeys.otherProfile)
        vc.username = "namho" //todo 
        vc.isLocalUser = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleTransfer() {
        Helper().saveToFolder(link: post.link!, completion: { (alertController) in
            self.present(alertController, animated: true, completion: nil)
        }) { (spotifyController) in
            self.present(spotifyController, animated: true, completion: nil)
        }
    }
    
    @objc func handlePan(gesture : UIPanGestureRecognizer) {
        let pan = gesture.translation(in: view).y
        //scrolling up
        
        switch  gesture.state {
        case .began, .changed:
            if lowerView.center.y + pan > view.center.y  && pan + scrollView.frame.origin.y < 20 {
                panUp(pan)
            }
            print("has been updated")
        
        case .ended :
            print("ended")
        default:
            print("defaulted")
        }
    }
    
    
    //Takes in a y pan value and scales it, then pans the view accordingly
    fileprivate func panUp(_ value: CGFloat) {
        print("we are panning upward")
        let pan = value * 0.1
        //pan up each element
        scrollView.center.y += pan
        labels.center.y += pan
        lowerView.center.y += pan
        lowerView.frame.size.height -= pan
    }
    
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }
    
    //TODO make compatible for videos
    //creates the activity controller when the user taps on the menu options icon
    //only works for images right now
    @objc func postActivityController() {
        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else { return }
        guard let image = postImage.image else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        viewController.present(activityController, animated: true) {
            print("working with the activity controller")
        }
    }
    
}

