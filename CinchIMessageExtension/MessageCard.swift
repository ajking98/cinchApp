//
//  MessageCard.swift
//  Gems
//
//  Created by Ahmed Gedi on 10/25/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import AVKit
import SDWebImage

class MessageCard: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    //player variables
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    ///given a UIImage, Int, and String, and sets the values of the post to the details given
    func buildPostCard(url: URL) {
        let size = self.frame.size
        
        //imageView
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
        
        //Imageview on Top of View
        imageView!.contentMode = .scaleAspectFill
        imageView!.clipsToBounds = true
        imageView.frame.size = size
        
    }
    
    ///given a URL, Int, and String, and sets the values of the post to the details given
    func buildVideoPostCard(url : URL) {
        let size = self.frame.size
        
        //video
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        imageView.layer.addSublayer(playerLayer)
        playerLayer.frame = imageView.bounds
        player.play()
        player.isMuted = true
        loopVideo(videoPlayer: player)
        
        imageView!.contentMode = .scaleAspectFill
        imageView!.clipsToBounds = true
        imageView.frame.size = size
    }
    
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }
    
    ///Given a item, sets the values of the post to that item's values
    func buildPostCard(item : String) {
        if item.contains("mp4") {
            buildVideoPostCard(url: URL(string: item)!)
        }
        else {
            buildPostCard(url: URL(string: item)!)
        }
    }
}