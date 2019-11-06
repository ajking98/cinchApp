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

// zoomingImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))

class ZoomingImage : UIImageView {
    var longPressedBool = false
    
    init(image : UIImage, frame: CGRect){
        super.init(frame: frame)
        self.image = image
        self.frame = frame
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupView(any : Any, zoomOut : Selector, longPressed : Selector) {
        self.layer.name = "zooming_image_view"
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: any, action: zoomOut))
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: any, action: longPressed))
        
    }
    
    func swipe(target: Any, action: Selector, direction: UISwipeGestureRecognizer.Direction){
        let swipe = UISwipeGestureRecognizer(target: target, action: action)
        swipe.direction = direction
        self.addGestureRecognizer(swipe)
    }
}



