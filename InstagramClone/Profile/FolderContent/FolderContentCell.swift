//
//  FolderContentCell.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 10/20/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class FolderContentCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    func buildPostCard(link: String) {
        let url = URL(string: link)
        print("here is your url:" , url)
        imageView.sd_setImage(with: url, completed: nil)
        imageView.image = UIImage(named: link)
    }
    
}
