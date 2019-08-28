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
    - Followers
    - Following
    - biography
    - isDarkModeEnabled
    - newContent
    - SuggestedContent
 
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
        DB.child(user).child("name").observeSingleEvent(of: .value) { (snapshot) in
            if let name = snapshot.value as? String {
                completion(name)
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
        DB.child(user).child("email").observeSingleEvent(of: .value) { (snapshot) in
            if let email = snapshot.value as? String {
                completion(email)
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
    //TODO check over this one and make it restricted!!
    func readPassword(user : String, completion: @escaping (String) -> Void) {
        DB.child(user).child("password").observeSingleEvent(of: .value) { (snapshot) in
            if let password = snapshot.value as? String {
                completion(password)
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
        DB.child(user).child("isPrivate").observeSingleEvent(of: .value) { (snapshot) in
            if let isPrivate = snapshot.value as? Bool {
                completion(isPrivate)
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
        DB.child(user).child("profilePic").observeSingleEvent(of: .value) { (snapshot) in
            if let profilePic = snapshot.value as? String {
                completion(profilePic)
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
        DB.child(user).child("dateCreated").observeSingleEvent(of: .value) { (snapshot) in
            if let dateCreated = snapshot.value as? String {
                completion(dateCreated)
            }
        }
    }
    
    func updateDateCreated(user : String, newDateCreated : String) -> Void {
        let DB = Database.database().reference().child("users").child(user)
        DB.updateChildValues(["dateCreated": newDateCreated])
    }
    
    func readDateLastActive(user : String, completion: @escaping (String) -> Void) {
        DB.child(user).child("dateLastActive").observeSingleEvent(of: .value) { (snapshot) in
            if let dateLastActive = snapshot.value as? String {
                completion(dateLastActive)
            }
        }
    }
    
    func updateDateLastActive(user : String, newDateLastActive : String) -> Void {
        let DB = Database.database().reference().child("users").child(user)
        DB.updateChildValues(["dateLastActive": newDateLastActive])
    }

    
    /*
        Followers
    */
    ///reads the number of followers a given user has
    func readFollowers(user : String, completion: @escaping ([String : String]) -> Void) {
        DB.child(user).child("followers").observeSingleEvent(of: .value) { (snapshot) in
            if let followers = snapshot.value as? [String : String] {
                completion(followers)
            }
        }
    }
    
    ///Adds a follower to the user - Should be given an official username
    func addFollower(user : String, newFollower : String) {
        DB.child(user).child("followers").updateChildValues([newFollower : newFollower])
    }
    
    
    ///removes a follower from the user's followers list
    func deleteFollower(user : String, follower : String) {
        self.DB.child(user).child("followers").child(follower).removeValue()
    }
    
    
    ///this removes all the followers and replaces it with the newly given list
    fileprivate func updateFollowers(user : String, newFollowers : [String]) {
        var list : [String : String] = [:]
        for follower in newFollowers {
            list[follower] = follower
        }
        DB.child(user).updateChildValues(["followers" : list])
    }
    
    
    /*
     Following
    */
    func readFollowing(user : String, completion : @escaping ([String : String]) -> Void) {
        DB.child(user).child("following").observeSingleEvent(of: .value) { (snapshot) in
            if let following = snapshot.value as? [String : String] {
                completion(following)
            }
        }
    }
    
    
    
    /*
     Folders
    */
    //CREATE
    ///Creates a new folder under the user in the database
    func addFolder(user : String, folder : Folder) -> Void {
        let folderArray = UserDefaults.standard.array(forKey: defaultsKeys.folderKey) as! [String]
        if !folderArray.contains(folder.folderName!) {
            let location = DB.child(user).child("folders").child(folder.folderName!)
            location.updateChildValues(folder.toString())
            addToFolderKey(folderName: folder.folderName!)
        }
    }
    
    func addToFolderKey(folderName:String) -> Void {
        var folderArray = UserDefaults.standard.array(forKey: defaultsKeys.folderKey) as! [String]
        folderArray.append(folderName)
        UserDefaults.standard.set(folderArray, forKey: defaultsKeys.folderKey)
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
        print("You cannot recover deleted folder")
        let DB = Database.database().reference().child("users").child(String(describing: user)).child("folders").child(folderName).removeValue()
        deleteFolderKey(folderName: folderName)
        return Folder(folderName: folderName)
    }
    
    func deleteFolderKey(folderName:String) -> Void {
        var folderArray = UserDefaults.standard.array(forKey: defaultsKeys.folderKey) as! [String]
        if let index = folderArray.index(of: folderName) {
            folderArray.remove(at: index)
        }
        UserDefaults.standard.set(folderArray, forKey: defaultsKeys.folderKey)
    }
}
