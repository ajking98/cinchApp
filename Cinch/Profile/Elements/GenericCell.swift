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
                //fetch thumbnail

                PostStruct().readThumbnail(link: link) { (thumbnailLink) in
                    print("this is the thumbnail", thumbnailLink)
                    guard let thumbnailURL = URL(string: thumbnailLink) else { return }
                    
                    self.imageView.loadVideo(thumbnailURL, size: self.frame.size)
                }
//                PostStruct().hasThumbnail(link: link) { (hasThumbnail) in
//                    if hasThumbnail {
//                        PostStruct().readThumbnail(link: link) { (thumbnailLink) in
//                            print("this is the thumbnail", thumbnailLink)
//                            guard let thumbnailURL = URL(string: thumbnailLink) else { return }
//
//                            self.imageView.loadVideo(thumbnailURL, size: self.frame.size)
//                        }
//                    }
//                    else {
//                        print("this should create something here")
//                        do { //If the thumbnail does not exist, then it should create one 
//                            try time {
//                                if let sourceURL = URL(string: link) {
//                                    let asset = AVURLAsset(url: sourceURL)
//                                    let trimmedAsset = try asset.assetByTrimming(timeOffStart: 1.5) //Only getting 1.5 second
//                                    let playerItem = AVPlayerItem(asset: trimmedAsset)
//                                    StorageStruct().uploadVideo(video: playerItem) { (thumbnailLink) in
//                                        print("we are uploading the thumbnail")
//                                        PostStruct().addThumbnail(linkOfPost: link, linkToThumbnail: thumbnailLink)
//                                    }
//                                }
//                            }
//                        } catch let error {
//                            print("💩 \(error)")
//                        }
//                    }
//                }
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
