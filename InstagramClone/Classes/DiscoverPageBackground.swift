//
//  DiscoverPageBackground.swift
//  InstagramClone
//
//  Created by Alsahlani, Yassin K on 5/28/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit



class DiscoverBackGround : UIView {
    
    
    let colorDefault = UIColor.black
    let colorOnHold = UIColor.lightGray
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        setupView()
    }
    
    func setupView(){
        self.backgroundColor = colorDefault
        self.alpha = 0
        self.layer.name = "black_background"
        self.isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

