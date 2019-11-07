//
//  PhotoCell.swift
//  Cinch
//
//  Created by Gedi, Ahmed M on 4/14/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var imageName: String! {
        didSet {
            photoImageView.image = UIImage(named: imageName)
        }
    }
    
}
