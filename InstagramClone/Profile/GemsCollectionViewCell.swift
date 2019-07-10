//
//  GemsCollectionViewCell.swift
//  InstagramClone
//
//  Created by Gedi on 7/6/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class GemsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet var title: UILabel!
    @IBOutlet weak var addImageButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func displayContent(title: String) {
        self.title.text = title
    }

}
