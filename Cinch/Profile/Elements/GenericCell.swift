//
//  GenericCell.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 2/3/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import AVKit
import SDWebImage

class GenericCell: UICollectionViewCell {
    var imageView = UIImageView()
    
    func setup(link: String){
        guard let contentLink = URL(string: link) else { return }
        if checkIfVideo(link) {
            imageView.loadVideo(contentLink, size: frame.size)
        }
        else {
            imageView.sd_setImage(with: URL(string: link), placeholderImage: UIImage(), completed: nil)
        }
        //constraints
        addSubview(imageView)
        imageView.frame.size = frame.size
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
    }
    
    override func prepareForReuse() {
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        imageView = UIImageView()
    }
}
