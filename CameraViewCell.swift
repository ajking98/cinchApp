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
    var content : NSObject!
    
    ///builds the style for the cell and adds the video/image to it 
    func setUp() {
        layer.borderColor = UIColor.selected.cgColor
        if let image = content as? UIImage {
            imageView.image = image
        }
        else if let video = content as? AVPlayerItem {
            let player = addPlayer(view: imageView, playerItem: video)
        }
    }
    
    override func prepareForReuse() {
        undoTap()
        layer.sublayers?.forEach({ (sublayer) in
            sublayer.removeFromSuperlayer()
        })
    }
    
    ///reverts the cell back to its normal state
    func undoTap() {
        isTapped = false
        layer.borderWidth = 0
    }
    
    func handleTap() {
        isTapped = true
        layer.borderWidth = 3
        print("We are doing the tapping asdf ")
    }
    
    
}
