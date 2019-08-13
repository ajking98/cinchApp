//
//  DiscoverController2.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 8/9/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit


class SecondaryDiscoverController: DiscoverController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("yes, this is working")
        
        collectionView.center.y = 550
        
        buildSizes()
        unNormalize(scrollView: collectionView)
    }

    func buildSizes() {
        print("Building size")
        let y = searchBar!.frame.origin.y + searchBar!.frame.height + 30
        collectionView.frame = CGRect(x: 0, y: y, width: view.frame.width, height: 200)
    }
    
    
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("this is scrolling")
    }
    
}
