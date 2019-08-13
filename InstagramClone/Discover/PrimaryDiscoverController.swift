//
//  MainDiscover.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 8/9/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit



class PrimaryDiscoverController: DiscoverController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        updateSearchBar()
    }
    
    
    func updateSearchBar() {
        searchBar?.center.y += 30
    }
    
    
    
    
    
    //when user scrolls in the scrollview, the view should pan and either move the segment control out the view or into the view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let gesture = scrollView.panGestureRecognizer
        
        if (scrollView.contentOffset.y < -60){
            scrollView.contentOffset.y = -60
        }
        
        //TODO clean this up
        switch gesture.state {
            
        case .began, .changed:
            let translation = gesture.translation(in: scrollView.superview).y * 0.1
            
            
            //if the segment control is less than or equal to the normalized center, then continue
            guard (segmentControl.center.y + translation) <= segmentControlCenter!.y else {
                return
            }
            
            //if pan is in the negative direction and the segment control hasn't reached its peak height
            if (translation < 0 && segmentControl.center.y > (-10 - segmentControl.frame.height)){
                segmentControl.center.y += translation
                buttonBar.center.y += translation
                searchBar!.center.y += translation
            }
            
            //if the summation of the translation and scrollview y-axis is within bounds
            // bounds are: 100 < origin.y < scrollViewFrame.y
            print("should", scrollView.frame)
            if(100 < scrollView.frame.origin.y + translation && scrollView.frame.origin.y + translation <= (scrollViewFrame?.origin.y)!){
                guard scrollView.frame.origin.y > 102 else {
                    return
                }
                print("should be doing this")
                collectionView.center.y += translation
                collectionView.frame.size.height -= translation
                
                tableView.center.y += translation
                tableView.frame.size.height -= translation
            }
        case .ended:
            //refresh the scrollviews
            if scrollView.contentOffset.y <= -50 && !isRefreshing {
                
                //vibrate for feedback
                let vibration = UIImpactFeedbackGenerator(style: .medium)
                vibration.impactOccurred()
                
                //refresh view
                refresh(scrollView: scrollView)
            }
            
            //if user swipes down quickly
            guard !(gesture.velocity(in: scrollView.superview).y > 120) else{
                normalize(scrollView: scrollView)
                return
            }
            
            //if user swipes up really quick
            if(gesture.velocity(in: scrollView.superview).y < -120 && scrollView.frame.origin.y > 100) {
                unNormalize(scrollView: scrollView)
            }
        default: break
        }
    }
    
    
    
}
