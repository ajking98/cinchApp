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
    
    ///takes a contentKey to the content it should build
    func setup(contentKey: String, _ errorHandler: (() -> Void)? = nil){
        let updatedLink = convertStringToKey(link: contentKey)
        PostStruct().readLink(contentKey: updatedLink) { (link) in
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
        imageView.backgroundColor = .skyBlue
    }
    
    ///sets up the cell using a post - iMessage
    func setup(post: Post, _ errorHandler: (() -> Void)? = nil) {
        addSubview(imageView)
        imageView.frame.size = frame.size
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .skyBlue
        
        
        guard let link = post.link else { return }
        let contentKey = post.contentKey
        if post.isImage! {
            self.imageView.sd_setImage(with: URL(string: link), placeholderImage: UIImage()) { (image, error, cacheType, link) in
                if error != nil {
                    errorHandler?()
                }
            }
        }
        else {
            //fetch thumbnail
            guard contentKey != "" else {
                return
            }
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
    }
    
    
    override func prepareForReuse() {
        imageView.stopAnimating()
        imageView.image = UIImage()
        imageView.removeFromSuperview()
    }
}
