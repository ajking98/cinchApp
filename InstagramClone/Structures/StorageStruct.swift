//
//  StorageStruct.swift
//  InstagramClone
/*
        Adds Images and videos to storage
            -For profile image, Folder icon, and Images/Videos to Folder
 */

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage


struct StorageStruct {
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
    func UploadFolderIcon<T>(user : T, folderName : String, image : UIImage)-> Bool{
        if user == nil {
            //Perform operation for uuid
            let uuid = UIDevice.current.identifierForVendor?.uuidString
            var data = Data()
            data = image.jpegData(compressionQuality: 0.8)!
            
            let refImages = Database.database().reference().child("users").child(uuid!).child("folders").child(folderName)
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
        } else {
            //perform operation given a username
            var data = Data()
            data = image.jpegData(compressionQuality: 0.8)!
            
            let refImages = Database.database().reference().child("users").child(String(describing: user)).child("folders").child(folderName)
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
        }
        return true
    }
    // TODO
    //Uploads Images and Videos to storage
    //T is for user, can be of type UUID or String (username)
    //folderName is the name of the folder the user wants to upload the image to
    //U is for content, can be of type UIImage or AVplayer
    //Uploads the content to the Storage and includes the url in the user's folder's content (In Database)
    func UploadContent<T,U>(user: T, folderName : String, content : U)->Bool{
        guard user is UUID else {
            
            //perform username given
            guard content is UIImage else {
                //perform AVplayer given
                return true
            }
                //perform Image given
            //perform operation given a username
            var data = Data()
            data = (content as! UIImage).jpegData(compressionQuality: 0.8)!
            
            let refImages = Database.database().reference().child("users").child(String(describing: user)).child("folders").child(folderName).child("content")
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
        
        //Perform UUID given
        guard content is UIImage else {
            //perform AVplayer given
            return true
        }
            //Perform Image given
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        var data = Data()
        data = (content as! UIImage).jpegData(compressionQuality: 0.8)!
        
        let refImages = Database.database().reference().child("users").child(uuid!).child("folders").child(folderName).child("content")
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
