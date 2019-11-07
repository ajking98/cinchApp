//
//  HomeCollectionViewCell.swift
//  Cinch
//
//  Created by Gedi, Ahmed M on 4/19/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
