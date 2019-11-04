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
//    var main = ViewController();
    let username = String(UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!)
    
    
    //TODO this should take in a closure to handle the frontend work or even uses a protocol to send the data back to the Main ViewController and have the vc do the presenting from inside its class
    ///takes an image and UIViewController and creates the alert for saving image to folder and tag alertbox 
    func saveToFolder(image: UIImage, viewController : UIViewController) {
        //Folder pick
        let actionController = SpotifyActionController()
        actionController.headerData = SpotifyHeaderData(title: "select a folder for the image?", subtitle: "", image: image)
        
        //1.
        //read in folders live from database
        //Store image into storage and get link
        //add new content to Folder in DB using FolderStruct
        
        
        //2.
        //Should take in tags
        
        UserStruct().readFolders(user: username) { (folders) in
            for item in folders {
                actionController.addAction(Action(ActionData(title: "\(item.lowercased())", subtitle: "For Content"), style: .default, handler: { action in
                    
                    
                    //todo Later, this "Testing" string in the next line should be given a link instead of static string
                    StorageStruct().uploadImage(image: image, completion: { (link) in
                        let alert = self.createTagsAlert(link: link, username: self.username)//Tagging alert
                        viewController.present(alert, animated: true, completion: nil)
                        
                        FolderStruct().addContent(user: self.username, folderName: item, link: link)
                        FolderStruct().updateNumOfImagesByConstant(user: self.username, folderName: item, constant: 1)
                    })
                    
                }))
            }
            
            viewController.present(actionController, animated: true, completion: nil)
        }
    }

    //Takes in a link and two closures
    //the first closure is for the tagging alert and the second closure is for the folder saving alert
    func saveToFolder(link: String, completion: @escaping(UIAlertController) -> Void, completion2 : @escaping(SpotifyActionController) -> Void) {
        //Folder pick
        let actionController = SpotifyActionController()
        actionController.headerData = SpotifyHeaderData(title: "select a folder for the image?", subtitle: "", image: UIImage(named: "empty")!)
        
        UserStruct().readFolders(user: username) { (folders) in
            for item in folders {
                actionController.addAction(Action(ActionData(title: "\(item.lowercased())", subtitle: "For Content"), style: .default, handler: { action in
                    
                    let alert = self.createTagsAlert(link: link)//Tagging alert
                    completion(alert)
                    FolderStruct().addContent(user: self.username, folderName: item, link: link)
                    FolderStruct().updateNumOfImagesByConstant(user: self.username, folderName: item, constant: 1)
                }))
            }
            completion2(actionController)
        }
    }
    
    
    ///takes an array of images and appends them to the storage
    func saveMultipleImages(images : [UIImage], viewController : UIViewController){
        let actionController = SpotifyActionController()
        actionController.headerData = SpotifyHeaderData(title: "select a folder for the images?", subtitle: "", image: images[0])
        
        
        UserStruct().readFolders(user: username) { (folders) in
            for item in folders {
                actionController.addAction(Action(ActionData(title: "\(item.lowercased())", subtitle: "For Content"), style: .default, handler: { action in
                    
                    for image in images {
                        StorageStruct().uploadImage(image: image, completion: { (link) in
                            
                            ParentPostStruct().addPost(post: Post(isImage: false, postOwner: self.username, link: link))
                            FolderStruct().addContent(user: self.username, folderName: item, link: link)
                            FolderStruct().updateNumOfImagesByConstant(user: self.username, folderName: item, constant: 1)
                        })
                    }
                }))
            }
            viewController.present(actionController, animated: true, completion: nil)
        }
    }
    
    
    ///Takes a string to the content, and saves the tags under that string
    func createTagsAlert(link: String, username : String? = nil)-> UIAlertController {
        //Add tag
        let alert = UIAlertController(title: "tags", message: "tag this gem to find it later", preferredStyle: .alert)
        alert.addTextField { (textField) in
            
        }
        alert.addAction(UIAlertAction(title: "done", style: .default, handler: { (_) in
            if let messages = alert.textFields {
                guard let message = messages[0].text?.components(separatedBy: CharacterSet(charactersIn: " ./")) else { return }
                var tagArray = [String]()
                for tag in message{
                    if tag.count > 2 {
                        tagArray.append(String(tag).lowercased())
                    }
                }
                if username != nil {
                    ParentPostStruct().addPost(post: Post(isImage: !link.contains(".mp4"), postOwner: username!, link: link))
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

    
    
    
    
    

