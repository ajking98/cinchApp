//
//  CameraViewCell.swift
//  Cinch
//
//  Created by Ahmed Gedi on 6/17/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import AVKit
import Foundation

class CameraViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    ///returns the index of the image it was given
    var currentIndex = 0
    
    var isTapped = false
    
    //player variables
//    var playerItem: AVPlayerItem!
//    var player: AVPlayer!
//    var playerLayer: AVPlayerLayer!
    
//    func buildPostCard(url : URL) {
//        let size = self.frame.size
//
//        //imageView
//        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
//
//        //Imageview on Top of View
//        imageView!.contentMode = .scaleAspectFill
//        imageView!.clipsToBounds = true
//        imageView.frame.size = size
//    }
    
    ///given a URL, Int, and String, and sets the values of the post to the details given
//    func buildVideoPostCard(url : URL) {
//        let size = self.frame.size
//
//        //video
//        playerItem = AVPlayerItem(url: url)
//        player = AVPlayer(playerItem: playerItem)
//        playerLayer = AVPlayerLayer(player: player)
//        playerLayer.videoGravity = .resize
//        imageView.layer.addSublayer(playerLayer)
//        playerLayer.frame = imageView.bounds
//        player.play()
//        player.isMuted = true
//        loopVideo(videoPlayer: player)
//
//        imageView!.contentMode = .scaleAspectFill
//        imageView!.clipsToBounds = true
//        imageView.frame.size = size
//    }
    
//    ///Given a item, sets the values of the post to that item's values
//    func buildPostCard(item : Post) {
//        guard let link = item.link else { return }
//
//        self.link = link
//        if link.contains("mp4") {
//            buildVideoPostCard(url: URL(string: link)!)
//        } else {
//            buildPostCard(url: URL(string: link)!)
//        }
//    }
//
//    //keeps the video in a constant loop
//    func loopVideo(videoPlayer: AVPlayer) {
//        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
//            videoPlayer.seek(to: CMTime.zero)
//            videoPlayer.play()
//        }
//    }
    
}
