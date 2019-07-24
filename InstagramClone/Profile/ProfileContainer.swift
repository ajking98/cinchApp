//
//  ProfileContainer.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 6/30/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

//RIBBIT
//Thanks I guess <3 


import Foundation
import UIKit

class ProfileContainer: UIViewController {
    @IBOutlet weak var rightMenuSideConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(toggleSideMenu),
                                               name: NSNotification.Name(rawValue: "Toggle Side Menu"),
                                               object: nil)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        firstView.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOut))
        firstView.addGestureRecognizer(tapGesture)
        print("Second View \(secondView.center.x)" )
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
    
    @objc func handleTapOut(gesture: UITapGestureRecognizer) {
        isExpanded = false
        rightMenuSideConstraint.constant = 300
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            let translation = gesture.translation(in: self.view)
            print(gesture.view!.center.x)
            print("First View \(self.firstView.center.x)" )
            print("Second View \(self.secondView.center.x)" )
            if(gesture.view!.center.x < 600) {
                self.firstView.center = CGPoint(x: gesture.view!.center.x + translation.x,y: gesture.view!.center.y)
                self.secondView.center = CGPoint(x: self.secondView.center.x + translation.x,y: self.firstView.center.y)
                gesture.view!.center = self.firstView.center
            }else {
                self.firstView.center = CGPoint(x: 206, y: gesture.view!.center.y)
            }
            
            gesture.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
        } else if gesture.state == .ended {
            if gesture.view!.center.x < 50 {
                UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: [], animations: {
//                    gesture.view!.center = CGPoint(x: -90, y: gesture.view!.center.y)
                    self.secondView.center = CGPoint(x: 300, y: gesture.view!.center.y)
                   self.rightMenuSideConstraint.constant = 0
                    self.isExpanded = true
                }, completion: nil)
                
            } else {
                UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: [], animations: {
                    gesture.view!.center = CGPoint(x: 207, y: gesture.view!.center.y)
                   self.secondView.center = CGPoint(x: 564, y: gesture.view!.center.y)
                    self.rightMenuSideConstraint.constant = 300
                    self.isExpanded = false
                }, completion: nil)
            }
        }
    }
}
