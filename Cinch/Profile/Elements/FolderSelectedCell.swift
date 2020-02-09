//
//  FolderSelectedCell.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 2/3/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import AVKit
import SDWebImage

class FolderSelectedCell: UICollectionViewCell {
    var imageView = UIImageView()
    
    func setup(link: String){
        cleanup()
        guard let contentLink = URL(string: link) else { return }
        if checkIfVideo(link) {
            print("this si the frame:", frame.size)
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

    func cleanup() {
        imageView = UIImageView()
        //TODO: these are the subviews 
//        print("these are the subviews:", subviews.count)
//        subviews[0].removeFromSuperview()
    }
}
