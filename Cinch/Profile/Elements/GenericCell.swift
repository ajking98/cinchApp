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
    
    func setup(link: String, _ errorHandler: (() -> Void)? = nil){
        guard let contentLink = URL(string: link) else { return }
            if checkIfVideo(link) {
                //fetch thumbnail
                PostStruct().readThumbnail(link: link) { (thumbnailLink) in
                    print("this is the thumbnail", thumbnailLink)
                    guard let thumbnailURL = URL(string: thumbnailLink) else { return }
                    
                    self.imageView.loadVideo(thumbnailURL, size: self.frame.size)
                }
            }
        else {
                imageView.sd_setImage(with: URL(string: link), placeholderImage: UIImage()) { (image, error, cacheType, link) in
                    if error != nil {
                        errorHandler?()
                    }
                }
                //TODO: work on on an animated image for videos
//                var urls:[URL] = []
//                print("this is setting the images up")
//                urls.append(URL(string: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__340.jpg")!)
//                urls.append(URL(string: "https://image.shutterstock.com/image-photo/bright-spring-view-cameo-island-260nw-1048185397.jpg")!)
//                urls.append(URL(string: "https://images.unsplash.com/photo-1503803548695-c2a7b4a5b875?ixlib=rb-1.2.1&w=1000&q=80")!)
//                urls.append(URL(string: "https://cdn.pixabay.com/photo/2013/07/21/13/00/rose-165819__340.jpg")!)
//                imageView.sd_setAnimationImages(with: urls)
//                imageView.animationDuration = 0.4
                
        }
        //constraints
        addSubview(imageView)
        imageView.frame.size = frame.size
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
//        imageView.backgroundColor = .lightGray
    }
    
    override func prepareForReuse() {
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        imageView = UIImageView()
    }
}
