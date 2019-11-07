//
//  ProfileCollectionViewCell.swift
//  Cinch
//
//  Created by Gedi, Ahmed M on 4/14/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
}
