//
//  ShareButton.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 8/8/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit

class ShareButton : UIButton {
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    
    func setUp() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapped)))
        self.isUserInteractionEnabled = true
        
        self.setImage(UIImage.init(named: "icons8-share-arrow"), for: .normal)
    }
    
    @objc func handleTapped() {
        print("handling tap")
    }
    
}


class MenuOptions: UIButton {
    
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    
    func setUp(){
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        self.isUserInteractionEnabled = true
        
        self.setImage(UIImage(named: "icons8-menu-vertical"), for: .normal)
    }
    
    
    @objc func handleTap() {
        print("handling menu options")
    }
}




class LikeButton : UIButton {
    
    var isActive = false
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    
    func setUp() {
        self.setImage(UIImage.init(named: "icons8-heart-unpressed"), for: .normal)
        
        self.addTarget(self, action: #selector(handleLikePressed), for: .touchUpInside)
    }
    
    
    @objc func handleLikePressed() {
        if isActive {
            unLike()
        }
        else {
            like()
        }
        isActive = !isActive
    }
    
    func like() {
        print("Liked")
        UIView.animate( withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            self.setImage(UIImage.init(named: "icons8-heart-pressed"), for: .normal)
            self.transform = CGAffineTransform(scaleX: 2, y: 2)
            Helper().vibrate(style: .heavy)
        })
        UIView.animate( withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    
    func unLike() {
        UIView.animate( withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            self.setImage(UIImage.init(named: "icons8-heart-unpressed"), for: .normal)
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            Helper().vibrate(style: .light)
        })
    }
}

