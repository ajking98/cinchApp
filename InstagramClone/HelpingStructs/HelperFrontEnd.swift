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
    
    
    
}

    
    
    
    
    

