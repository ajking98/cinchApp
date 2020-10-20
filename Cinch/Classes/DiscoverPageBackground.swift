//
//  DiscoverPageBackground.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 5/28/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit



class DiscoverBackGround : UIView {
    
    let colorOnHold = UIColor.secondarySystemBackground
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        setupView()
    }
    
    func setupView(){
        let inverseSystemBackground: UIColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
        self.backgroundColor = inverseSystemBackground
        self.alpha = 0
        self.layer.name = "black_background"
        self.isUserInteractionEnabled = true
        
    }
    
    
    func swipe(target: Any, action: Selector, direction: UISwipeGestureRecognizer.Direction){
        let swipe = UISwipeGestureRecognizer(target: target, action: action)
        swipe.direction = direction
        self.addGestureRecognizer(swipe)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

