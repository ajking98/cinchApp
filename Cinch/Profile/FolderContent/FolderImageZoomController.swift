//
//  FolderImageZoomController.swift
//  Cinch
//
//  Created by Ahmed Gedi on 11/8/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import AVKit

class FolderImageZoomController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image = UIImage(named: "placeholder.png")
    var link = ""
    var isImage = true
    
    @IBOutlet weak var dismissView: UIView!
    //player variables
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = image
        // Do any additional setup after loading the view.
        if !isImage {
            addVideo(link: self.link)
        }
        animateDismissal()
        addGestures()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
}
