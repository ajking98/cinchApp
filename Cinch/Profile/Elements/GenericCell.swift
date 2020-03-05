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
    
    ///takes a link to the content it should build
    func setup(link: String, _ errorHandler: (() -> Void)? = nil){
        guard let contentLink = URL(string: link) else { return }
            if checkIfVideo(link) {
                //fetch thumbnail
                PostStruct().readThumbnail(link: link) { (thumbnailLink) in
                    if thumbnailLink.isEmpty { return }
                    self.imageView.sd_setAnimationImages(with: thumbnailLink)
                    self.imageView.animationDuration = 1.4
                    self.imageView.sd_setHighlightedImage(with: thumbnailLink[0], completed: nil)
                    self.imageView.startAnimating()
                }
            }
        else {
                imageView.sd_setImage(with: URL(string: link), placeholderImage: UIImage()) { (image, error, cacheType, link) in
                    if error != nil {
                        errorHandler?()
                    }
                }
        }
        //constraints
        addSubview(imageView)
        imageView.frame.size = frame.size
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
    }
    
    override func prepareForReuse() {
        imageView = UIImageView()
    }
}
