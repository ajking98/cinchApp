//
//  StorageStruct.swift
//  Cinch
/*
        Adds Images and videos to storage
            -For profile image, Folder icon, and Images/Videos to Folder
 */

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage


struct StorageStruct {
    
    
    
    ///Upload image to storage and uses closure to return URL
    func uploadImage(image : UIImage, completion: @escaping(String) -> Void) {
        var imageData = Data()
        imageData = image.jpegData(compressionQuality: 0.8)!
        
        
        let storageRef = Storage.storage().reference().child("PublicImages/" + randomString(20))
        storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
            guard (metadata != nil) else{
                print("Error occurred in the upload process")
                return
            }
            
            storageRef.downloadURL {(url, error) in
                guard let downloadURL = url else {
                    print("Error occurred")
                    return
                }
                completion(downloadURL.absoluteString)
            }
        })
    }
    
    
    
    // WORKS
    //Uploads image to Firebase Storage and adds the path to the firebase database under the user's profile image key
    func UploadProfilePic(user : String, image : UIImage) -> Bool {
            //Perform operation for Username given
        var data = Data()
        data = image.jpegData(compressionQuality: 0.8)!
        
        let refImages = Database.database().reference().child("users").child(user)
        let storageRef = Storage.storage().reference().child("userImages/" + randomString(20))
        
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
                        let image = [downloadUrl.absoluteString]
                        let dict = ["profilePic": image]
                        refImages.updateChildValues(dict)
                    }
                }
                guard let url = url else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
        return true
    }
    
    
    // Works
    //Uploads image to storage and sets it as the icon pic for the given folder for that given user
    func UploadFolderIcon(user : String, folderName : String, image : UIImage)-> Bool{
        var data = Data()
        data = image.jpegData(compressionQuality: 0.8)!
        
        let refImages = Database.database().reference().child("users").child(user).child("folders").child(folderName)
        let storageRef = Storage.storage().reference().child("userImages/" + randomString(20))
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
                        let image = [downloadUrl.absoluteString]
                        let dict = ["icon": image]
                        refImages.updateChildValues(dict)
                    }
                }
                guard let url = url else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
        return true
    }
    
    
    // TODO
    ///Uploads Images and Videos to storage
    func UploadContent(user: String, folderName : String, content : UIImage)->Bool{
            //perform Image given
        var data = Data()
        data = content.jpegData(compressionQuality: 0.8)!
            
        let refImages = Database.database().reference().child("users").child(user).child("folders").child(folderName).child("content")
        let storageRef = Storage.storage().reference().child("userImages/" + randomString(20))
        
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
//                            refImages.observeSingleEvent(of: .value) { (snapshot) -> Void in
//                                var contentArr = [String]()
//                                for image in snapshot.children {
//                                    contentArr.append(image as! String)
//                                }
//                                contentArr.append(content as! )
//                            }
                        
                        refImages.observeSingleEvent(of: .value, with: { snapshot in
                            var myContentArray = [String]()
                            for child in snapshot.children {
                                let snap = child as! DataSnapshot
                                let value = snap.value as! String
                                myContentArray.append(value)
                                
                            }
                            let image = downloadUrl.absoluteString
                            myContentArray.append(image)
                            refImages.setValue(myContentArray)
                        })
                        
                    }
                }
                guard let url = url else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
        return true
    }
    
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
}
