//
//  FolderContentCell.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 10/20/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import SDWebImage

class FolderContentCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    func buildPostCard(link: String) {
        let url = URL(string: link)
        imageView.sd_setImage(with: url, completed: nil)
    }
    
}
