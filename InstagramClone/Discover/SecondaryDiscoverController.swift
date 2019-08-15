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
    
    var y:CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("yes, this is working")
        
        buildSizes()
    }

    func buildSizes() {
        print("Building size")
        y = segmentControl!.frame.origin.y + segmentControl!.frame.height + 30
        print("frame", collectionView.frame)
        collectionView.frame = CGRect(x: 0, y: y, width: view.frame.width, height: (view.frame.height - view.center.y) - 50)
        tableView.frame.size = collectionView.frame.size
        print("frame after", collectionView.frame)
        
        scrollViewFrame = collectionView.frame
    }
    
    
    //Brings the scroll view back down to its original height and brings back the segment control view
    override func normalize(scrollView : UIScrollView, _ speed : Double? = nil) {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            scrollView.frame = self.scrollViewFrame!
            print("normalizing")
            
            guard let scrollViewFrame = self.scrollViewFrame else {
                return
            }
            print("normalizing is the frame", scrollViewFrame)
            //brings down the segment control
            guard let speed = speed else {
                self.normalizeSegmentView(velocity: 0.24)
                self.structureFrame(y: self.y, height: scrollViewFrame.height, 0.24)
                return
            }
            
            self.normalizeSegmentView(velocity: speed)
            self.structureFrame(y: self.y, height: scrollViewFrame.height, speed)
            
        }, completion: nil)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let gesture = scrollView.panGestureRecognizer
        let translation = gesture.translation(in: view).y * 0.04
        
        if scrollView.center.y + translation < view.frame.height - 150 &&  scrollView.frame.origin.y + translation > 0 {
            moveAll(translation: translation)
        }
        
        print("frame", scrollView.frame)
    }
    
    func moveAll(translation : CGFloat) {
        
        //scrollview
        collectionView.frame.origin.y += translation
        tableView.frame.origin.y += translation
        
        //segment control
        segmentControl.frame.origin.y += translation
        buttonBar.frame.origin.y += translation
        
    }
    
}
