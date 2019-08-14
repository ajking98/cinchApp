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
        
        buildSizes()
    }

    func buildSizes() {
        print("Building size")
        let y = segmentControl!.frame.origin.y + segmentControl!.frame.height + 30
        print("frame", collectionView.frame)
        collectionView.frame = CGRect(x: 0, y: y, width: view.frame.width, height: view.frame.height - view.center.y)
        print("frame after", collectionView.frame)
    }
    
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let gesture = scrollView.panGestureRecognizer
        let translation = gesture.translation(in: view).y * 0.04
        
        if scrollView.center.y + translation < view.frame.height - 100 &&  scrollView.frame.origin.y + translation > 0 {
            print("die")
            moveAll(translation: translation)
        }
        
        print("frame", scrollView.frame)
    }
    
    func moveAll(translation : CGFloat) {
        
        //scrollview
        collectionView.frame.origin.y += translation
        
        //segment control
        segmentControl.frame.origin.y += translation
        buttonBar.frame.origin.y += translation
        
    }
    
}
