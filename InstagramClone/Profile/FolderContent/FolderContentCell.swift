//
//  FolderContentCell.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 10/20/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

class FolderContentCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    //player variables
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    
    func buildPostCard(link: String) {
        guard let url = URL(string: link) else {
            return
        }
        
        if link.contains(".mp4") {
            //video
            playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resize
            imageView.layer.addSublayer(playerLayer)
            playerLayer.frame.size = self.frame.size
            player.play()
            player.isMuted = true
            loopVideo(videoPlayer: player)
            
            imageView!.contentMode = .scaleAspectFill
            imageView!.clipsToBounds = true
        }
        else {
            imageView.sd_setImage(with: url, completed: nil)
        }
        
    }
    
    
    //keeps the video in a constant loop
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }
    
}
