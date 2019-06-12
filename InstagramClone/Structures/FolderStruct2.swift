//
//  FolderStruct2.swift
//  InstagramClone
/*
    Responsible for interacting within the Folders dropdown in the database
 
    Contains RU commands for the following variables: Read, Update
        - dateCreated
        - dateLastModified
        - icon
        - numOfImages
        - numOfVideos
        - isPrivate
 
 
    Contains CRUD commands for: Create, Read, Update, Delete (User should be able to delete a content, add a new content, update and existing content, and see a selected content)
        - content
 
 Generic Type <T> can be either the UUID (if the user hasn't set up an account yet) or a username (if one exists)
 */

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage


struct FolderStruct {
    let DB = Database.database().reference().child("users")
    let uuid = UIDevice.current.identifierForVendor!
    /*
     DateCreated
    */
    //returns Date the folder was created
    func readDateCreated<T>(user : T, folderName: String, dateCreatedClosure: @escaping (String) -> Void) -> Void{
        guard user is UUID else {
            DB.child(String(describing: user)).child("folders").child(folderName).observeSingleEvent(of: .value) { (snapshot) -> Void in
                if let dict = snapshot.value as? [String:Any] {
                    var dateCreated:String?
                    let value = snapshot.value as? NSDictionary
                    dateCreated = value?["dateCreated"] as? String ?? ""
                    dateCreatedClosure(dateCreated!)
                }
            }
            return
        }
        DB.child(uuid.uuidString).observeSingleEvent(of: .value) { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                var dateCreated:String?
                let value = snapshot.value as? NSDictionary
                dateCreated = value?["dateCreated"] as? String ?? ""
                dateCreatedClosure(dateCreated!)
            }
        }
        return
    }
    
    
    //Updates the dateCreated attribute in the database and returns true if successful
    func updateDateCreated<T>(user : T, folderName : String, newDateCreated : Date) -> Bool {
        guard user is UUID else {
            //Handle username
            let DB = Database.database().reference().child("users").child(String(describing: user)).child("folders").child(folderName)
            DB.updateChildValues(["dateCreated": newDateCreated.toString()])
            return true
        }
        //Handle UUID
        let DB = Database.database().reference().child("users").child(uuid.uuidString).child("folders").child(folderName)
        DB.updateChildValues(["dateCreated": newDateCreated.toString()])
        return true
    }
    
    
    /*
     DateLastModified
     */
    //returns the date of when the folder was last edited by the user
    func readDateLastModified<T>(user : T, folderName: String, dateLastModifiedClosure: @escaping (String) -> Void) -> Void{
        guard user is UUID else {
            DB.child(String(describing: user)).child("folders").child(folderName).observeSingleEvent(of: .value) { (snapshot) -> Void in
                if let dict = snapshot.value as? [String:Any] {
                    var dateLastModified:String?
                    let value = snapshot.value as? NSDictionary
                    dateLastModified = value?["dateLastModified"] as? String ?? ""
                    dateLastModifiedClosure(dateLastModified!)
                }
            }
            return
        }
        DB.child(uuid.uuidString).observeSingleEvent(of: .value) { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                var dateLastModified:String?
                let value = snapshot.value as? NSDictionary
                dateLastModified = value?["dateLastModified"] as? String ?? ""
                dateLastModifiedClosure(dateLastModified!)
            }
        }
        return
    }
    
    
    //Updates the dateLastModified attribute in the database
    //should be called once the user makes any edits on a folder
    func updateDateLastModified<T>(user : T, folderName : String, newDateLastModified : Date) -> Bool {
        guard user is UUID else {
            //Handle username
            let DB = Database.database().reference().child("users").child(String(describing: user)).child("folders").child(folderName)
            DB.updateChildValues(["dateLastModified": newDateLastModified.toString()])
            return true
        }
        //Handle UUID
        let DB = Database.database().reference().child("users").child(uuid.uuidString).child("folders").child(folderName)
        DB.updateChildValues(["dateLastModified": newDateLastModified.toString()])
        return true
    }
    
    
    /*
     Icon
    */
    //gets the icon for the folder from the database
    func readIcon<T>(user : T, folderName: String, folderIconClosure: @escaping (String) -> Void) -> Void{
        guard user is UUID else {
            DB.child(String(describing: user)).child("folders").child(folderName).observeSingleEvent(of: .value) { (snapshot) -> Void in
                if let dict = snapshot.value as? [String:Any] {
                    var icon:String?
                    let value = snapshot.value as? NSDictionary
                    icon = value?["icon"] as? String ?? ""
                    folderIconClosure(icon!)
                }
            }
            return
        }
        DB.child(uuid.uuidString).observeSingleEvent(of: .value) { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                var icon:String?
                let value = snapshot.value as? NSDictionary
                icon = value?["icon"] as? String ?? ""
                folderIconClosure(icon!)
            }
        }
        return
    }
    
    //updates the icon in the database for that given folder
    func updateIcon<T>(user : T, folderName: String, newIcon : UIImage) -> Bool {
        guard user is UUID else {
            //Handle username
            let DB = Database.database().reference().child("users").child(String(describing: user)).child("folders").child(folderName)
            DB.updateChildValues(["icon": newIcon.toString()])
            return true
        }
        //Handle UUID
        let DB = Database.database().reference().child("users").child(uuid.uuidString).child("folders").child(folderName)
        DB.updateChildValues(["icon": newIcon.toString()])
        return true
    }
    
    //Method overloading and takes a string instead of UIImage so that we dont upload the same image multiple times
    func updateIcon<T>(user : T, folderName: String, newIcon : String) -> Bool {
        guard user is UUID else {
            //Handle username
            let DB = Database.database().reference().child("users").child(String(describing: user)).child("folders").child(folderName)
            DB.updateChildValues(["icon": newIcon])
            return true
        }
        //Handle UUID
        let DB = Database.database().reference().child("users").child(uuid.uuidString).child("folders").child(folderName)
        DB.updateChildValues(["icon": newIcon])
        return true
    }
    
    
    
    /*
     numOfImages
    */
    //returns the number of Images the user has as content in that folder
    //Is helpful to the user to show some stats about each folder and helpful for us to collect data on which is more preffered (Videos or Images)
    func readNumOfImages<T>(user : T, folderName: String, numOfImagesClosure: @escaping (Int) -> Void) -> Void{
        guard user is UUID else {
            DB.child(String(describing: user)).child("folders").child(folderName).observeSingleEvent(of: .value) { (snapshot) -> Void in
                if let dict = snapshot.value as? [String:Any] {
                    var numOfImages:Int?
                    let value = snapshot.value as? NSDictionary
                    numOfImages = value?["numOfImages"] as? Int ?? 0
                    numOfImagesClosure(numOfImages!)
                }
            }
            return
        }
        DB.child(uuid.uuidString).observeSingleEvent(of: .value) { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                var numOfImages:Int?
                let value = snapshot.value as? NSDictionary
                numOfImages = value?["numOfImages"] as? Int ?? 0
                numOfImagesClosure(numOfImages!)
            }
        }
        return
    }
    
    
    //updates the numOfImages value in the database and returns true if done successfully
    //should be called whenever the user uploads a new image to a selected folder
    func updateNumOfImages<T>(user :T, folderName : String, newNumOfImages : Int) -> Bool {
        guard user is UUID else {
            //Handle username
            let DB = Database.database().reference().child("users").child(String(describing: user)).child("folders").child(folderName)
            DB.updateChildValues(["numOfImages": newNumOfImages])
            return true
        }
        //Handle UUID
        let DB = Database.database().reference().child("users").child(uuid.uuidString).child("folders").child(folderName)
        DB.updateChildValues(["numOfImages": newNumOfImages])
        return true
    }
    
    
    
    /*
     numOfVideos
    */
    //returns the number of Videos the user has as content in that folder
    //Is helpful to the user to show some stats about each folder and helpful for us to collect data on which is more preffered (Videos or Images)
    func readNumOfVideos<T>(user : T, folderName: String, numOfVideosClosure: @escaping (Int) -> Void) -> Void{
        guard user is UUID else {
            DB.child(String(describing: user)).child("folders").child(folderName).observeSingleEvent(of: .value) { (snapshot) -> Void in
                if let dict = snapshot.value as? [String:Any] {
                    var numOfVideos:Int?
                    let value = snapshot.value as? NSDictionary
                    numOfVideos = value?["numOfVideos"] as? Int ?? 0
                    numOfVideosClosure(numOfVideos!)
                }
            }
            return
        }
        DB.child(uuid.uuidString).observeSingleEvent(of: .value) { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                var numOfVideos:Int?
                let value = snapshot.value as? NSDictionary
                numOfVideos = value?["numOfVideos"] as? Int ?? 0
                numOfVideosClosure(numOfVideos!)
            }
        }
        return
    }
    
    //updates the numOfVideos value in the database and returns true if done successfully
    //should be called whenever the user uploads a new video to a selected folder
    func updateNumOfVideos<T>(user : T, folderName : String, newNumOfVideos : Int) -> Bool {
        guard user is UUID else {
            //Handle username
            let DB = Database.database().reference().child("users").child(String(describing: user)).child("folders").child(folderName)
            DB.updateChildValues(["numOfVideos": newNumOfVideos])
            return true
        }
        //Handle UUID
        let DB = Database.database().reference().child("users").child(uuid.uuidString).child("folders").child(folderName)
        DB.updateChildValues(["numOfVideos": newNumOfVideos])
        return true
    }
    
    /*
     isPrivate
    */
    //Checks the isPrivate attribute in the database
    //Helpful to determine if the folder should be shown publicly or not
    func readPrivate<T>(user : T, folderName: String, isPrivateClosure: @escaping (Bool) -> Void) -> Void{
        guard user is UUID else {
            DB.child(String(describing: user)).child("folders").child(folderName).observeSingleEvent(of: .value) { (snapshot) -> Void in
                if let dict = snapshot.value as? [String:Any] {
                    var isPrivate:Bool?
                    let value = snapshot.value as? NSDictionary
                    isPrivate = value?["isPrivate"] as? Bool ?? false
                    isPrivateClosure(isPrivate!)
                }
            }
            return
        }
        DB.child(uuid.uuidString).observeSingleEvent(of: .value) { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                var isPrivate:Bool?
                let value = snapshot.value as? NSDictionary
                isPrivate = value?["isPrivate"] as? Bool ?? false
                isPrivateClosure(isPrivate!)
            }
        }
        return
    }
    
    
    //changes the value of isPrivate in the database to the given newIsPrivate boolean value
    //Is called when the user wishes to change the permission on that folder
    func updateIsPrivate<T>(user : T, folderName : String, newIsPrivate : Bool)->Bool {
        guard user is UUID else {
            //Handle username
            let DB = Database.database().reference().child("users").child(String(describing: user)).child("folders").child(folderName)
            DB.updateChildValues(["isPrivate": newIsPrivate])
            return true
        }
        //Handle UUID
        let DB = Database.database().reference().child("users").child(uuid.uuidString).child("folders").child(folderName)
        DB.updateChildValues(["isPrivate": newIsPrivate])
        return true
    }
    
    
    
}
