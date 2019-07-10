//
//  ProfileContainer.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 6/30/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit

class ProfileContainer: UIViewController {
    @IBOutlet weak var rightMenuSideConstraint: NSLayoutConstraint!
    var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(toggleSideMenu),
                                               name: NSNotification.Name(rawValue: "Toggle Side Menu"),
                                               object: nil)
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }
    @objc func toggleSideMenu() {
        if isExpanded {
            isExpanded = false
            rightMenuSideConstraint.constant = 300
        } else {
            isExpanded = true
            rightMenuSideConstraint.constant = 0
        }
    }
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            UIView.animateKeyframes(withDuration: 1, delay: 0.7, options: [], animations: {
                self.isExpanded = true
                self.rightMenuSideConstraint.constant = 0
            }, completion: nil)
        } else if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            UIView.animateKeyframes(withDuration: 1, delay: 0.7, options: [], animations: {
                self.isExpanded = false
                self.rightMenuSideConstraint.constant = 300
            }, completion: nil)
        }
        
    }
}
