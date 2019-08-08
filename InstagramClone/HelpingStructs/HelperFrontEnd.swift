//
//  HelperFrontEnd.swift
//  Helper
//
//  Created by Gedi on 5/27/19. 
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit
import XLActionController
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SQLite


struct Helper {
    let uuid = UIDevice.current.identifierForVendor!
    var userVar = User()
    var foldersVar = [String]()
    var main = ViewController();
    let username = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)
    
    func saveToFolder(image: UIImage) -> SpotifyActionController {
        let actionController = SpotifyActionController()
        
        actionController.headerData = SpotifyHeaderData(title: "Which folder do you want to save to?", subtitle: "", image: image)
        
        let defaults = main.userDefaults
        let foodArray = defaults.object(forKey: defaultsKeys.folderKey) as? [String] ?? [String]()
        print(foodArray.count)
        for item in foodArray {
            actionController.addAction(Action(ActionData(title: "\(item.uppercased())", subtitle: "For Content"), style: .default, handler: { action in
                print("the button has been clicked")
                print(item)
                StorageStruct().UploadContent(user: UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!, folderName: item, content: image)
                
            }))
            
        }
        
        return actionController
    }
    
    func vibrate(style : UIImpactFeedbackGenerator.FeedbackStyle){
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
    
    
    func animateIn(zoomingImageView: UIView, keyWindow: UIWindow){
        //Animate Inwards
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {
            zoomingImageView.frame = CGRect(x:0, y:0, width: keyWindow.frame.width * 0.9, height: (zoomingImageView.frame.height) * 0.9)
            zoomingImageView.center = keyWindow.center
            
        }, completion: { (completed: Bool) in
        })
        
    }
    
    
    func animateOut(zoomingImageView : ZoomingImage, blackBackgroundView : DiscoverBackGround, startingFrame : CGRect){
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            zoomingImageView.frame = startingFrame
            blackBackgroundView.alpha = 0
        }, completion: { (completed: Bool) in
            zoomingImageView.removeFromSuperview()
            
        })
    }
}

    
    
    
    
    

