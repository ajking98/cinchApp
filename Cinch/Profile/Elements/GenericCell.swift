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
    func setup(contentKey: String, _ errorHandler: (() -> Void)? = nil){
        PostStruct().readLink(contentKey: contentKey) { (link) in
            if checkIfVideo(link) {
                //fetch thumbnail
                PostStruct().readThumbnail(contentKey: contentKey) { (thumbnailLink) in
                    var smoothedThumbnail = thumbnailLink
                    smoothedThumbnail.append(contentsOf: thumbnailLink.reversed())
                    if smoothedThumbnail.isEmpty { return }
                    self.imageView.sd_setAnimationImages(with: smoothedThumbnail)
                    self.imageView.animationDuration = 2.8
                    self.imageView.sd_setHighlightedImage(with: smoothedThumbnail[0], completed: nil)
                    self.imageView.startAnimating()
                }
            }
        else {
                self.imageView.sd_setImage(with: URL(string: link), placeholderImage: UIImage()) { (image, error, cacheType, link) in
                    if error != nil {
                        errorHandler?()
                    }
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
