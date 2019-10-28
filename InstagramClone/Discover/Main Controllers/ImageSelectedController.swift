//
//  ImageSelectedController.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 7/5/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import AVKit

class ImageSelectedController: UIViewController {
    var post : Post!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lowerView: UIView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var labels: UIView!
    var likeButton = LikeButton()
    var shareButton = ShareButton()
    var likesView = UILabel(frame: CGRect.zero)
    var authorView = UILabel(frame: CGRect.zero)
    
    
    //player variables
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        
        setUpScrollView()
        labels.addGestureRecognizer((navigationController?.interactivePopGestureRecognizer)!)

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
        
        //likeButton
        likeButton.center = CGPoint(x: 30, y: centerY)
        
        //share Button
        shareButton.center = CGPoint(x: labels.frame.width - 30, y: centerY)
        
        
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
        labels.addSubview(likeButton)
        labels.addSubview(likesView)
        labels.addSubview(authorView)
        labels.addSubview(shareButton)
        
        lowerView.frame.size.width = view.frame.width
        lowerView.center.x = view.center.x
        
        
        lowerView.isUserInteractionEnabled = true
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
    
    
    
}

