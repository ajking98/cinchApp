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
    
    ///takes a contentKey  & errorHandler for if the content is missing
    func setup(contentKey: String, _ errorHandler: (() -> Void)? = nil){
        var imageView = UIImageView()
        let updatedLink = convertStringToKey(link: contentKey)
        PostStruct().readLink(contentKey: contentKey, completion: { (link) in
                if checkIfVideo(link) {
                    //fetch thumbnail
                    PostStruct().readThumbnail(contentKey: contentKey) { (thumbnailLink) in
                        var smoothedThumbnail = thumbnailLink
                        smoothedThumbnail.append(contentsOf: thumbnailLink.reversed())
                        if smoothedThumbnail.isEmpty { return }
                        imageView.sd_setAnimationImages(with: smoothedThumbnail)
                        imageView.animationDuration = 2.8
                        imageView.sd_setHighlightedImage(with: smoothedThumbnail[0], completed: nil)
                        imageView.startAnimating()
                    }
                }
            else {
                    imageView.sd_setImage(with: URL(string: link), placeholderImage: UIImage()) { (image, error, cacheType, link) in
                        if error != nil {
                            errorHandler?()
                        }
                    }
                }
        }) {
            print("this content is missing", contentKey)
            errorHandler?()
        }
        
        if contentKey.contains("cdn.memes") {
            print("this ius the link to the image:", contentKey)
            imageView.sd_setImage(with: URL(string: contentKey), placeholderImage: UIImage()) { (image, error, cacheType, link) in
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
        imageView.backgroundColor = .skyBlue
    }
    
    ///sets up the cell using a post - iMessage
    func setup(post: Post, _ errorHandler: (() -> Void)? = nil) {
        var imageView = UIImageView()
        addSubview(imageView)
        imageView.frame.size = frame.size
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .skyBlue
        
        
        guard let link = post.link else { return }
        let contentKey = post.contentKey
        if post.isImage! {
            imageView.sd_setImage(with: URL(string: link), placeholderImage: UIImage()) { (image, error, cacheType, link) in
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
                imageView.sd_setAnimationImages(with: smoothedThumbnail)
                imageView.animationDuration = 2.8
                imageView.sd_setHighlightedImage(with: smoothedThumbnail[0], completed: nil)
                imageView.startAnimating()
            }
        }
    }
    
    
    override func prepareForReuse() {
//        imageView.stopAnimating()
//        imageView.image = UIImage()
//        imageView.removeFromSuperview()
        self.subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
    }
}
