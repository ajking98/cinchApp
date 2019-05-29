//
//  HelperFrontEnd.swift
//  Helper
//
//  Created by Gedi on 5/27/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import XLActionController


struct Helper {
    
    func saveToFolder(image: UIImage) -> SpotifyActionController {
        
        let actionController = SpotifyActionController()
        
        actionController.headerData = SpotifyHeaderData(title: "Which folder do you want to save to?", subtitle: "", image: image)
        
        for x in 0 ... 5{
            actionController.addAction(Action(ActionData(title: "Folder #\(x)", subtitle: "For Content"), style: .default, handler: nil))
            
        }
        
        return actionController
    }
    
    
    func vibrate(style : UIImpactFeedbackGenerator.FeedbackStyle){
        //medium level vibration feedback
        let vibration = UIImpactFeedbackGenerator(style: style)
        vibration.impactOccurred()
    }
    
    
    func animateIn(iconsView : UIView, zoomingImageView : UIView, keyWindow : UIWindow) {
        //Animate Inwards
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {
            zoomingImageView.frame = CGRect(x:0, y:0, width: keyWindow.frame.width * 0.95, height: (zoomingImageView.frame.height) * 0.95)
            zoomingImageView.center = keyWindow.center
            
            iconsView.isHidden = false
            keyWindow.bringSubviewToFront(iconsView)
        }, completion: { (completed: Bool) in
        })
    }
}



    
    
    
    
    

