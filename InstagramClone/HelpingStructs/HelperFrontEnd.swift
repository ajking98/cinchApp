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
    
    
    ///takes an image and UIViewController and creates the alert for saving image to folder and tag alertbox 
    func saveToFolder(image: UIImage, viewController : UIViewController) -> SpotifyActionController {
        //Folder pick
        let actionController = SpotifyActionController()
        
        actionController.headerData = SpotifyHeaderData(title: "which folder do you want to save to?", subtitle: "", image: image)
        
        let defaults = main.userDefaults
        let foodArray = defaults.object(forKey: defaultsKeys.folderKey) as? [String] ?? [String]()
        print(foodArray.count)
        for item in foodArray {
            actionController.addAction(Action(ActionData(title: "\(item.uppercased())", subtitle: "For Content"), style: .default, handler: { action in
                
                
                //todo Later, this "Testing" string in the next line should be given a link instead of static string
                let alert = self.createTagsAlert(link: "Testing")
                viewController.present(alert, animated: true, completion: nil)
                StorageStruct().UploadContent(user: UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!, folderName: item, content: image)
                
            }))

        }
        
        return actionController
    }
    
    
    ///Takes a string to the content, and saves the tags under that string
    func createTagsAlert(link: String)-> UIAlertController {
        //Add tag
        let alert = UIAlertController(title: "tags", message: "tag this gem to find it later", preferredStyle: .alert)
        alert.addTextField { (textField) in
            
        }
        alert.addAction(UIAlertAction(title: "done", style: .default, handler: { (_) in
            if let messages = alert.textFields {
                guard let message = messages[0].text?.split(separator: " ") else { return }
                var tagArray = [String]()
                for tag in message{
                    tagArray.append(String(tag))
                }
                PostStruct().addTags(post: link, newTags: tagArray)
            }
        }))
        
        return alert
    }
    
    
    func vibrate(style : UIImpactFeedbackGenerator.FeedbackStyle){
        let vibration = UIImpactFeedbackGenerator(style: style)
        vibration.impactOccurred()
    }
    
    
    
}

    
    
    
    
    

