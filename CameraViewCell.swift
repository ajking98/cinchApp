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
    var content: NSObject?
    
    ///builds the style for the cell
    func setUp() {
        layer.borderColor = UIColor.selected.cgColor
        if let image = content as? UIImage {
            imageView.image = image
        }
        else if let playerItem = content as? AVPlayerItem {
            imageView.image = UIImage(named: "playIcon")
            //TODO fix this so that the video will be playing inside the cell
//            let player = addPlayer(view: imageView, playerItem: playerItem)
        }
    }
    
    override func prepareForReuse() {
        print("falsing this cell", currentIndex)
        imageView.image = nil
        imageView.layer.sublayers?.forEach({ (sublayer) in
            print("this is one sublayer:", sublayer)
            sublayer.removeFromSuperlayer()
        })
        undoTap()
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
