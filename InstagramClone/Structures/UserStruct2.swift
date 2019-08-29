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
    - suggestedContent
 
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
        DB.child(user).child("followings").observeSingleEvent(of: .value) { (snapshot) in
            if let followings = snapshot.value as? [String : String] {
                completion(followings)
            }
        }
    }
    
    ///Adds a person to the user's followings list
    func addFollowing(user : String, newFollowing : String) {
        DB.child(user).child("followings").updateChildValues([newFollowing : newFollowing])
    }
    
    ///Removes a person from the user's followings list
    func deleteFollowing(user : String, following : String) {
        DB.child(user).child("followings").child(following).removeValue()
    }
    
    //removes all the previous followings and inserts the new list given
    fileprivate func updateFollowers(user : String, newFollowings : [String]){
        var list : [String : String] = [:]
        for following in newFollowings {
            list[following] = following
        }
        
        DB.child(user).updateChildValues(["followings" : list])
    }
    
    
    /*
    biography
    */
    
    ///Reads the biography of the given user
    func readBiography(user : String, completion : @escaping(String)-> Void) {
        DB.child(user).child("biography").observeSingleEvent(of: .value) { (snapshot) in
            if let biography = snapshot.value as? String {
                completion(biography)
            }
        }
    }
    
    ///updates the biography of the given user
    func updateBiography(user : String, newBiography : String) {
        DB.child(user).child("biography").setValue(newBiography)
    }
    
    
    /*
    isDarkModeEnabled
    */
    func readIsDarkModeEnabled(user : String, completion : @escaping(Bool) -> Void) {
        DB.child(user).child("isDarkModeEnabled").observeSingleEvent(of: .value) { (snapshot) in
            if let isDarkModeEnabled = snapshot.value as? Bool {
                completion(isDarkModeEnabled)
            }
        }
    }
    
    
    func updateIsDarkModeEnabled(user : String, newIsDarkModeEnabled : Bool){
        DB.child(user).child("isDarkModeEnabled").setValue(newIsDarkModeEnabled)
    }
    
    
    /*
    newContent
     is an array of links that can be put against the posts node in the database
    */
    ///Reads the new content
    func readNewContent(user : String, completion : @escaping([String : String]) -> Void) {
        DB.child(user).child("newContent").observeSingleEvent(of: .value) { (snapshot) in
            if let newContent = snapshot.value as? [String : String] {
                completion(newContent)
            }
        }
    }
    
    
    ///adds new post links to the user's new content
    func addNewContent(user : String, link : String) {
        DB.child(user).child("newContent").child(link).setValue(link)
    }
    
    
    ///deletes a post link from the user's new content
    func deleteNewContent(user : String, link : String) {
        DB.child(user).child("newContent").child(link).removeValue()
    }
    
    
    ///Updates the whole newContent instance in the DB. Replaces all existing data with new given data for user
    func updateNewContent(user : String, newContents : [String]) {
        var content : [String : String] = [:]
        for newContent in newContents {
            content[newContent] = newContent
        }
        DB.child(user).child("newContent").setValue(content)
    }
    
    
    
    /*
     suggestedContent
     is an array of links that can be put against the posts node in the database
     */
    ///Reads the suggested content
    func readSuggestedContent(user : String, completion : @escaping([String : String]) -> Void) {
        DB.child(user).child("suggestedContent").observeSingleEvent(of: .value) { (snapshot) in
            if let suggestedContent = snapshot.value as? [String : String] {
                completion(suggestedContent)
            }
        }
    }
    
    
    ///adds new post links to the user's suggestedContent
    func addSuggestedContent(user : String, link : String) {
        DB.child(user).child("suggestedContent").child(link).setValue(link)
    }
    
    
    ///deletes a post link from the user's new content
    func deleteSuggestedContent(user : String, link : String) {
        DB.child(user).child("suggestedContent").child(link).removeValue()
    }
    
    
    ///Updates the whole suggestedContent instance in the DB. Replaces all existing data with new given data for user
    func updateSuggestedContent(user : String, newContents : [String]) {
        var content : [String : String] = [:]
        for newContent in newContents {
            content[newContent] = newContent
        }
        DB.child(user).child("suggestedContent").setValue(content)
    }
    
    
    
    
    
    
    
    
    
    
    /*
 
    TODO THIS NEEDS FIXING ASAP
 
    */
    
    func addFolder(user : String, folder : Folder) {
        DB.child(user).child("folders").updateChildValues([folder.folderName! : folder.toString()])
    }
    
    
    ///Reads folders from the database for the given user
    func readFolders(user : String, completion : @escaping([String])-> Void) {
        DB.child(user).child("folders").observeSingleEvent(of: .value) { (snapshot) in
            if let folders = snapshot.value as? [String : Any] {
                var folderNames : [String] = []
                for folder in folders {
                    folderNames.append(folder.key)
                }
                
                completion(folderNames)
            }
        }
    }
    
    
    ///deletes a folder for the given user
    func deleteFolder(user : String, folderName : String) {
        DB.child(user).child("folders").child(folderName).removeValue()
    }
    
    ///replaces all existing folders in the database with the new list given
    func updateFolders(user : String, newFolders : [Folder]){
        var folders : [String : Any] = [:]
        for folder in newFolders {
            folders[folder.folderName!] = folder.toString()
        }
        
        DB.child(user).updateChildValues(["folders" : folders])
    }
    
    
    
    
}
