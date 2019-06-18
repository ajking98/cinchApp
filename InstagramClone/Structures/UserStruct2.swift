//
//  UserStruct2.swift
/*
 Stores RU commands the following variables: READ, UPDATE
    - name
    - email
    - password
    - isPrivate
    - profilePic
    - dateCreated
    - dateLastActive
 
 CRD commands for: CREATE, READ, DELETE
    - folders
    - tags
 
 
 Generic Type <T> can be either the UUID (if the user hasn't set up an account yet) or a username (if one exists)
 */

//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage

struct UserStruct {
    let DB = Database.database().reference().child("users")
    let uuid = UIDevice.current.identifierForVendor!
    
    /*
     Name
     */
    func readName(user : String, completion: @escaping (String) -> Void) {
        DB.child(user).observeSingleEvent(of: .value) { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                var name:String?
                let dictionary = snapshot.value as? NSDictionary
                name = dictionary?["name"] as? String ?? "Empty Name"
                completion(name!)
            }
        }
    }

    func updateName(user : String, newName : String) -> Void {
        let DB = Database.database().reference().child("users").child(user)
        DB.updateChildValues(["name": newName])
    }
    
    /*
        EMAIL
    */
    func readEmail(user : String, completion: @escaping (String) -> Void) {
        DB.child(user).observeSingleEvent(of: .value) { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                var email:String?
                let dictionary = snapshot.value as? NSDictionary
                email = dictionary?["email"] as? String ?? "Empty Email"
                completion(email!)
            }
        }
    }
    
    func updateEmail(user : String, newEmail : String) -> Void {
        let DB = Database.database().reference().child("users").child(user)
        DB.updateChildValues(["email": newEmail])
    }
    
    
    /*
     Password
     */
    func readPassword(user : String, completion: @escaping (String) -> Void) {
        DB.child(user).observeSingleEvent(of: .value) { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                var password:String?
                let dictionary = snapshot.value as? NSDictionary
                password = dictionary?["password"] as? String ?? "Empty Password"
                completion(password!)
            }
        }
    }
    
    func updatePassword(user : String, newPassword : String) -> Void {
        let DB = Database.database().reference().child("users").child(user)
        DB.updateChildValues(["password": newPassword])
    }

    /*
     isPrivate
    */
    func readIsPrivate(user : String, completion: @escaping (Bool) -> Void) {
        DB.child(user).observeSingleEvent(of: .value) { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                var isPrivate:Bool?
                let dictionary = snapshot.value as? NSDictionary
                isPrivate = dictionary?["isPrivate"] as? Bool ?? false
                completion(isPrivate!)
            }
        }
    }
    
    func updateIsPrivate(user : String, newIsPrivate : Bool) -> Void {
        let DB = Database.database().reference().child("users").child(user)
        DB.updateChildValues(["isPrivate": newIsPrivate])
    }
  
    /*
     ProfilePic
     */
    func readProfilePic(user : String, completion: @escaping (String) -> Void) {
        DB.child(user).observeSingleEvent(of: .value) { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                var profilePic:String?
                let dictionary = snapshot.value as? NSDictionary
                profilePic = dictionary?["profilePic"] as? String ?? "default image"
                completion(profilePic!)
            }
        }
    }

    // Existing Image
    func updateExistingProfilePic(user : String, newProfilePic : String) -> Void {
        let DB = Database.database().reference().child("users").child(user)
        DB.updateChildValues(["profilePic": newProfilePic])
    }
    
    // New Image
    func updateNewProfilePic(user: String, newProfilePic: UIImage) -> Void {
        StorageStruct().UploadProfilePic(user: UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!, image: newProfilePic)
    }
    
    /*
     DateCreated
    */
    func readDateCreated(user : String, completion: @escaping (String) -> Void) {
        DB.child(user).observeSingleEvent(of: .value) { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                var dateCreated:String?
                let dictionary = snapshot.value as? NSDictionary
                dateCreated = dictionary?["dateCreated"] as? String ?? ""
                completion(dateCreated!)
            }
        }
    }
    
    func updateDateCreated(user : String, newDateCreated : String) -> Void {
        let DB = Database.database().reference().child("users").child(user)
        DB.updateChildValues(["dateCreated": newDateCreated])
    }
    
    func readDateLastActive(user : String, completion: @escaping (String) -> Void) {
        DB.child(user).observeSingleEvent(of: .value) { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                var dateLastActive:String?
                let dictionary = snapshot.value as? NSDictionary
                dateLastActive = dictionary?["dateLastActive"] as? String ?? ""
                completion(dateLastActive!)
            }
        }
    }
    
    func updateDateLastActive(user : String, newDateLastActive : String) -> Void {
        let DB = Database.database().reference().child("users").child(user)
        DB.updateChildValues(["dateLastActive": newDateLastActive])
    }

    /*
     Folders
    */
    //CREATE
    //Creates a new folder under the user in the database and returns the newly added folder
    func addFolder(user : String, folder : Folder) -> Void {
        let location = DB.child(user).child("folders").child(folder.folderName!)
        location.updateChildValues(folder.toString())
    }
    
    //READ
    //returns all the folders the given user has in a folder array
    func readFolders(user : String, readFolderClosure: @escaping ([String]) -> Void) -> Void {
            DB.child(String(describing: user)).child("folders").observeSingleEvent(of: .value) { (snapshot) -> Void in
                var folder = [String]()
                for folders in snapshot.children {
                    folder.append(((folders as AnyObject).key))
                }
                readFolderClosure(folder)
            }
            return
    }
    
    // TODO Add read individual folder
    
    //Update
    //Is used to rename a folder
    func updateFolder<T>(user : T, prevFolderName: String, newFolderName: String, prevFolderinfo: Folder) -> Bool {
        guard user is UUID else {
            DB.child(String(describing: user)).child("folders").updateChildValues([newFolderName: prevFolderinfo.toString()])
            deleteFolder(user: String(describing: user), folderName: prevFolderName)
            return true
        }
        //Handle UUID
        DB.child(uuid.uuidString).child("folders").updateChildValues([newFolderName: prevFolderinfo.toString()])
        deleteFolder(user: String(describing: user), folderName: prevFolderName)
        return true
    }
    
    //Delete
    //Takes a user and a folder name and deletes the folder with that foldername from that user and returns the deleted folder
    func deleteFolder(user : String, folderName : String) ->Folder {
        let DB = Database.database().reference().child("users").child(String(describing: user)).child("folders").child(folderName).removeValue()
        return Folder(folderName: folderName)
    }
}
