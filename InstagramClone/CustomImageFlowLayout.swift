//
//  CustomImageFlowLayout.swift
//  InstagramClone
//
//  Created by Gedi, Ahmed M on 4/19/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class CustomImageFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override var itemSize: CGSize {
        set{}
        
        get {
            let numberOfCollumns: CGFloat = 3
            let itemWidth = (self.collectionView!.frame.width - (numberOfCollumns - 1)) / numberOfCollumns
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .vertical
    }

}
