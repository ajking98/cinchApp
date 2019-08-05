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
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleProfilePan))
        firstView.addGestureRecognizer(panGesture)
        
        let panMenuGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMenuPan))
        secondView.addGestureRecognizer(panMenuGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOut))
        firstView.addGestureRecognizer(tapGesture)
        print("First View \(firstView.center.x)" )
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
    
    @objc func handleProfilePan(gesture: UIPanGestureRecognizer) {
        gesture.isEnabled = true
        print(gesture.view!.center.x)
        if gesture.state == .began || gesture.state == .changed {
            let translation = gesture.translation(in: self.view)
            if(gesture.view!.center.x < 220) {
                self.firstView.center = CGPoint(x: gesture.view!.center.x + translation.x, y: gesture.view!.center.y)
                self.secondView.center = CGPoint(x: self.secondView.center.x + translation.x, y: self.firstView.center.y)
                gesture.view!.center = self.firstView.center
            }else {
                UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
                    self.firstView.center = CGPoint(x: 207, y: gesture.view!.center.y)
                    self.secondView.center = CGPoint(x: 564, y: gesture.view!.center.y)
                    gesture.isEnabled = false
                }, completion: nil)
            }
            
            gesture.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
        } else if gesture.state == .ended {
            print("Gesture View \(gesture.view!.center.x)")
            print("First View \(firstView.center.x)" )
            print("Second View \(secondView.center.x)" )
            if secondView.center.x < 400 {
                UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
                    self.firstView.center = CGPoint(x: -90, y: gesture.view!.center.y)
                    self.secondView.center = CGPoint(x: 260, y: gesture.view!.center.y)
                }, completion: nil)
                
            } else {
                UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
                    self.firstView.center = CGPoint(x: 207, y: gesture.view!.center.y)
                    self.secondView.center = CGPoint(x: 564, y: gesture.view!.center.y)
                }, completion: nil)
            }
        }
    }
    
    @objc func handleMenuPan(gesture: UIPanGestureRecognizer) {
        gesture.isEnabled = true
        print(gesture.view!.center.x)
        if gesture.state == .began || gesture.state == .changed {
            let translation = gesture.translation(in: self.view)
            if(gesture.view!.center.x > 190) {
                self.firstView.center = CGPoint(x: self.firstView.center.x + translation.x,y: gesture.view!.center.y)
                self.secondView.center = CGPoint(x: gesture.view!.center.x + translation.x,y: self.firstView.center.y)
                gesture.view!.center = self.secondView.center
            }else {
                UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
                    self.secondView.center = CGPoint(x: 260, y: gesture.view!.center.y)
                    self.firstView.center = CGPoint(x: -90, y: gesture.view!.center.y)
                    gesture.isEnabled = false
                }, completion: nil)
            }
            
            gesture.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
        } else if gesture.state == .ended {
            print("First View \(firstView.center.x)")
            if firstView.center.x < 0 {
                UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
                    self.firstView.center = CGPoint(x: -90, y: gesture.view!.center.y)
                    self.secondView.center = CGPoint(x: 260, y: gesture.view!.center.y)
                }, completion: nil)
                
            } else {
                UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
                    self.firstView.center = CGPoint(x: 207, y: gesture.view!.center.y)
                    self.secondView.center = CGPoint(x: 564, y: gesture.view!.center.y)
                }, completion: nil)
            }
        }
    }
    
}
