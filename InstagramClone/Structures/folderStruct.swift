//
//  folderStruct.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 5/28/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage

struct folderStruct {
    var folderName:String
    var icon:String
    var numOfImages:Int
    var numOfVideos:Int
    var isPrivate:Bool
    var dateCreated:String
    var dateModified:String
    var images:[String]
//    var videos:[String]?
    let uuid = UIDevice.current.identifierForVendor?.uuidString
    
    init() {
        folderName = ""
        icon = ""
        numOfImages = 0
        numOfVideos = 0
        isPrivate = false
        dateCreated = ""
        dateModified = ""
        images = [String]()
    }
    
    func readName() {
        var databaseReference: DatabaseReference!
        databaseReference = Database.database().reference()
        
        databaseReference.child("users").child(uuid!).child("folders").child(folderName).observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot.value as Any)
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func updateName(newName:String) {
        let refImages = Database.database().reference().child("users").child(uuid!).child("folders").child(folderName)
        refImages.setValue(newName)
    }
    
    func updateIcon(icon:String) {
        let refImages = Database.database().reference().child("users").child(uuid!).child("folders").child(folderName).child("icon")
        refImages.setValue(icon)
    }
    
    func deleteIcon(icon:String) {
        let refImages = Database.database().reference().child("users").child(uuid!).child("folders").child(folderName).child("icon")
        refImages.setValue("")
    }
    
    func readtNumOfImages() {
        var databaseReference: DatabaseReference!
        databaseReference = Database.database().reference()
        
        databaseReference.child("users").child(uuid!).child("folders").child(folderName).child("numOfImg").observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot.value as Any)
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func readtNumOfVideos() {
        var databaseReference: DatabaseReference!
        databaseReference = Database.database().reference()
        
        databaseReference.child("users").child(uuid!).child("folders").child(folderName).child("numOfVids").observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot.value as Any)
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func addNumOfImages(numOfImages:Int) {
        let refImages = Database.database().reference().child("users").child(uuid!).child("folders").child(folderName).child("numOfImg")
        var incrementedValue = numOfImages + 1
        refImages.setValue(incrementedValue)
    }
    
//    func addNumOfVideo(numOfVideos:Int) {
//        let refImages = Database.database().reference().child("users").child(uuid!).child("folders").child(folderName).child("numOfVids")
//        var incrementedValue = numOfVideos + 1
//        refImages.setValue(incrementedValue)
//    }
    
    func subtractNumOfImages(numOfImages:Int) {
        let refImages = Database.database().reference().child("users").child(uuid!).child("folders").child(folderName).child("numOfImg")
        var incrementedValue = numOfImages - 1
        refImages.setValue(incrementedValue)
    }
    
    //    func subtractNumOfVideo(numOfVideos:Int) {
    //        let refImages = Database.database().reference().child("users").child(uuid!).child("folders").child(folderName).child("numOfVids")
    //        var incrementedValue = numOfVideos - 1
    //        refImages.setValue(incrementedValue)
    //    }
    
    func readFolderPrivacy() {
        var databaseReference: DatabaseReference!
        databaseReference = Database.database().reference()
        
        databaseReference.child("users").child(uuid!).child("folders").child(folderName).child("private").observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot.value as Any)
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func updateFolderPrivacy(isPrivate:Bool) {
        let refImages = Database.database().reference().child("users").child(uuid!).child("folders").child(folderName).child("private")
        refImages.setValue(isPrivate)
    }
    
    // Use once
    func createDate() -> String {
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = dateformatter.string(from: NSDate() as Date)
        let refImages = Database.database().reference().child("users").child(uuid!).child("folders").child(folderName)
        refImages.setValue(now)
        return now
    }
    
    func updateDate() -> String {
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = dateformatter.string(from: NSDate() as Date)
        let refImages = Database.database().reference().child("users").child(uuid!).child("folders").child(folderName)
        refImages.setValue(now)
        return now
    }
    
//    func deleteImageFromFolder(folderName:String, imageUrl:String)   {
//        var imageArray = folder.getImages()
//        if let index = imageArray.firstIndex(of: imageUrl) {
//            imageArray.remove(at: index)
//        }
//    }
//
    func uploadImage(image:UIImage, folder:folderStruct) {
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        var data = Data()
        data = image.jpegData(compressionQuality: 0.8)!

        let refImages = Database.database().reference().child("users").child(uuid!).child("folders").child(folderName).child("images")
        let storageRef = Storage.storage().reference().child("userImages/" + randomString(20))
        print(storageRef.name)
        print(refImages)

        // Upload the file to the path "images/rivers.jpg"
        _ = storageRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                print("Error occurred")
                return
            }
            // Metadata contains file metadata such as size, content-type.

            // You can also access to download URL after upload.
            storageRef.downloadURL { (url, error) in
                if (error == nil) {
                    if let downloadUrl = url {
                        // Make you download string
                        let key = refImages.childByAutoId().key
                        let image = [downloadUrl.absoluteString]
                        refImages.child(key).setValue(image)
                    }
                }
                guard let url = url else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
    }
//
//    // TODO: Set up storing video
//    //    func uploadVideoToStorage() -> return type {
//    //        <#function body#>
//    //    }
//
    func removeImageFromDatabase(child: String) {
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        let ref = Database.database().reference().child("users").child(uuid!).child("folders").child(folderName).child("images")
        ref.child(child)

        ref.removeValue { error, _ in
            print(error)
        }
    }
//    // TODO: Delete video from database
//    //    func removeVideoFromDatabase(<#parameters#>) -> <#return type#> {
//    //        <#function body#>
//    //    }
//
    func randomString(_ length: Int) -> String {
        let letters : NSString = "asdfghjkloiuytrewqazxcvbnmWERTYUIASDFGHJKXCVBN"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
//    init(folderName:String, iconImage:String, numOfImages:Int, numOfVideos:Int, isPrivate:Bool, dateCreated:String, dateModified:String, imgs:[String], videos:[String]) {
//        self.folderName = folderName
//        self.iconImage = iconImage
//        self.numOfImages = numOfImages
//        self.numOfVideos = numOfVideos
//        self.isPrivate = isPrivate
//        self.dateCreated = dateCreated
//        self.dateModified = dateModified
//        self.imgs = imgs
//        self.videos = videos
//    }
}
