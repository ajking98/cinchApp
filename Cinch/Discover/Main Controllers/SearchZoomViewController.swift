//
//  SearchZoomViewController.swift
//  Cinch
//
//  Created by Ahmed Gedi on 11/12/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import AVKit

class SearchZoomViewController: UIViewController {

    //Labels
    @IBOutlet weak var labelContainer: UIView!
    var authorView = UILabel(frame: CGRect.zero)
    var menuOptions = MenuOptions()
    var shareButton = ShareButton()
    
    
    @IBOutlet weak var imageView: UIImageView!
    var image = UIImage(named: "placeholder.png")
    var link = ""
    var isImage = true
    @IBOutlet weak var dismissView: UIView!
    
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = image
        // Do any additional setup after loading the view.
        if !isImage {
            addVideo(link: self.link)
        }
        animateDismissal()
        addGestures()

        // Do any additional setup after loading the view.
        setUp()
    }
    
    func setUp() {
        
        let centerY = (labelContainer.frame.height / 2) - 5
        //Menu
        menuOptions.center = CGPoint(x: labelContainer.frame.width - 30, y: centerY)
        menuOptions.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(postActivityController)))
        
        //share Button
        shareButton.center = CGPoint(x: 30, y: centerY)
        shareButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTransfer)))
        
        //gestures for authorView
        authorView.isUserInteractionEnabled = true
        authorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAuthorPressed)))
        
        
        authorView.frame.size = CGSize(width: (labelContainer.frame.width / 2) - 10, height: 20)
        authorView.center = CGPoint(x: labelContainer.frame.width / 2, y: centerY)
        authorView.textAlignment = .center
        
        print("step 1")
        if let post = post {
            print("step 2", post.postOwner)
            authorView.text = post.postOwner
        }
        else if link.count > 1 {
            print("this is the limit reached", link)
            PostStruct().readPostOwner(post: link) { (author) in
                self.authorView.text = author
            }
        }
        
        //add subviews
        labelContainer.addSubview(menuOptions)
        labelContainer.addSubview(authorView)
        labelContainer.addSubview(shareButton)
        
    }
    
    func addVideo(link: String) {
        let size = self.imageView.frame.size
        let url = URL(string: link)
        //video
        playerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        imageView.layer.addSublayer(playerLayer)
        playerLayer.frame = imageView.bounds
        player.play()
        player.isMuted = true
        loopVideo(videoPlayer: player)
    }
    
    //keeps the video in a constant loop
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }
    
    @objc func closeAction(_ sender: Any) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
            self.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }
    
    func addGestures() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closeAction(_:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(swipeDown)
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMute)))
    }
    
    func animateDismissal() {
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: [.repeat, .autoreverse], animations: {
            
            self.moveDown(view: self.dismissView)
            
        }, completion: nil)
    }
    
    func moveDown(view: UIView) {
        view.center.y -= 25
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if playerLayer != nil {
            player.isMuted = true
        }
    }
    
    @objc func handleMute() {
        if playerLayer != nil {
            player.isMuted = !player.isMuted
        }
    }

    
    @objc func handleAuthorPressed() {
        let vc = UIStoryboard(name: "ProfilePage", bundle: nil).instantiateViewController(withIdentifier: "profilePage") as! ProfilePageViewController
        guard let author = authorView.text else { return }
        UserDefaults.standard.setValue(author, forKey: defaultsKeys.otherProfile)
        vc.username = author
        vc.isLocalUser = false
        print("this is the author", authorView.text)
        self.present(vc, animated: true)
    }
    
    //TODO make compatible for videos
    //creates the activity controller when the user taps on the menu options icon
    //only works for images right now
    @objc func postActivityController() {
        var activityController : UIActivityViewController
        if isImage {
            guard let image = image else { return }
            activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        }
        else {
            //todo add compatibility for video sharing - Right now it only shares the link 
            activityController = UIActivityViewController(activityItems: [link], applicationActivities: nil)
        }
        present(activityController, animated: true)
    }
    
    
    
    @objc func handleTransfer() {
        guard let post = post else { return }
        Helper().saveToFolder(link: post.link!, completion: { (alertController) in
            self.present(alertController, animated: true, completion: nil)
        }) { (spotifyController) in
            self.present(spotifyController, animated: true, completion: nil)
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
