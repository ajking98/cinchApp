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
    
    static var video: AVPlayerLayer?
    
    
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
        //TODO: handle local link
        let player = AVPlayer(url: link)
        return loadVideo(player, size: size)
    }

    ///embeds video into imageView given a playerItem
    public func loadVideo(_ player : AVPlayer, size: CGSize) -> AVPlayerLayer {
        player.isMuted = true
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame.size = size
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        player.play()
        return playerLayer
    }
    
    
}
