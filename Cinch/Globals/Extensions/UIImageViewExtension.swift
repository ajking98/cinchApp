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

///caches the avplayerlayers for the videos 
var cachedVideoPlayers = NSCache<NSString, AVPlayerLayer>()


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
        if let cachedPlayer = cachedVideoPlayers.object(forKey: link.absoluteString as NSString) {
            addPlayerToView(cachedPlayer, size: size)
            return cachedPlayer
        }
        else {
            let player = AVPlayer(url: link)
            let playerLayer = loadVideo(player, size: size)
            cachedVideoPlayers.setObject(playerLayer, forKey: link.absoluteString as NSString)
            return playerLayer
        }
    }

    ///embeds video into imageView given a playerItem
    public func loadVideo(_ player : AVPlayer, size: CGSize) -> AVPlayerLayer {
        player.isMuted = true
        let playerLayer = AVPlayerLayer(player: player)
        addPlayerToView(playerLayer, size: size)
        return playerLayer
    }
    
    public func addPlayerToView(_ playerLayer : AVPlayerLayer, size: CGSize){
        playerLayer.frame.size = size
        playerLayer.videoGravity = .resizeAspectFill
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
