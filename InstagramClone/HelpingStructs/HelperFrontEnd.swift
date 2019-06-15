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


struct Helper {
    let uuid = UIDevice.current.identifierForVendor!
    var userVar = User()
    var foldersVar = [String]()
    
//    func getAllData(user: User, folders:[String]) {
//        if Auth.auth().currentUser != nil {
//            // User is signed in.
//            print("hey")
//        } else {
//            ParentStruct().readUser(user: uuid.uuidString, userClosure: { (userInfo:User, dateCreated:String, dateLastActive:String, folders:Any) in
//                //handle read functionality
//                print("printing user: ", userInfo)
//                print("printing name: ", userInfo.name!)
//                print("noooooooooo")
//                UserStruct().readFolders(user: self.uuid.uuidString, readFolderClosure: {(folders:[String]) in
//                    for item in folders {
//                        print(item)
//                        print(userInfo.name!)
//                    }
//                })
//            })
//        }
//    }
    
    func saveToFolder(image: UIImage) -> SpotifyActionController {
        let actionController = SpotifyActionController()
        actionController.headerData = SpotifyHeaderData(title: "Which folder do you want to save to?", subtitle: "", image: image)
        if Auth.auth().currentUser != nil {
            // User is signed in.
            print("hey")
        } else {
            var date = ""
            ParentStruct().readUser(user: uuid.uuidString, completion: { (userInfo:User, dateCreated:String, dateLastActive:String, folders:Any) -> String in
                print("printing user: ", userInfo)
                print("printing name: ", userInfo.name!)
                date = userInfo.name!
                print("printing date: ",date)
                return ""
            })
            print("printing date: ",date)
            for item in 0...5 {
                actionController.addAction(Action(ActionData(title: "Folder #\(item)", subtitle: "For Content"), style: .default, handler: { action in
                    // do something useful
//                    self.dothething();
                }))
                
            }
        }
        
        return actionController
    }
//    func dothething() {
//        ParentStruct().readUser(user: self.uuid.uuidString, userClosure: { (userInfo:User, dateCreated:String, dateLastActive:String, folders:Any) in
//            //handle read functionality
//            print("printing user: ", userInfo)
//            print("printing name: ", userInfo.name!)
//            UserStruct().readFolders(user: self.uuid.uuidString, readFolderClosure: {(folders:[String]) -> Void in
//                for item in folders {
//                    print(item)
//                }
//            })
//        })
//    }
    

    
    
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



    
    
    
    
    

