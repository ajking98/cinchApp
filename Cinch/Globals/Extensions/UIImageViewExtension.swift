//
//  UIImageViewExtension.swift
//  Cinch
//
//  Created by Ahmed Gedi on 9/28/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit
import AVKit


extension UIImageView {
    
    
    public func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    @available(iOS 9.0, *)
    public func loadGif(asset: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(asset: asset)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    ///embeds video into imageView given a link
    public func loadVideo(_ link: URL, size: CGSize)-> AVPlayerLayer {
        let player = AVPlayer(url: link)
        return loadVideo(player, size: size)
    }

    ///embeds video into imageView given a playerItem
    public func loadVideo(_ player : AVPlayer, size: CGSize) -> AVPlayerLayer {
        player.isMuted = true
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame.size = size
        playerLayer.videoGravity = .resizeAspectFill
        addPlayerToView(playerLayer)
        return playerLayer
    }
    
    public func addPlayerToView(_ playerLayer : AVPlayerLayer){
        guard let player = playerLayer.player else { return }
        layer.addSublayer(playerLayer)
        player.play()
        
        //autoplay
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { notification in
            player.seek(to: CMTime.zero)
            player.play()
        }
    }
    
    
}
