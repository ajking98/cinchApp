//
//  ZoomingImage.swift
//  ZoomingImage

/*
    Contains the code to zoom the image
 */
//
//  Created by Alsahlani, Yassin K on 5/28/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit



class ZoomingImage : UIImageView {
    var longPressedBool = false
    init(image : UIImage, frame: CGRect){
        super.init(frame: frame)
        setupView()
        self.image = image
        self.frame = frame
    }
    
    func setupView() {
        self.layer.name = "zooming_image_view"
        self.isUserInteractionEnabled = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



