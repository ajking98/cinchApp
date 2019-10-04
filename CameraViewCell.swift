//
//  CameraViewCell.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 6/17/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import Foundation

class CameraViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    ///returns the index of the image it was given
    var currentIndex = 0
    
    var isTapped = false
    
    
    
}
