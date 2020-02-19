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
    
    
    func updateProfilePic(user : String, newProfilePic : String) -> Void {
        let DB = Database.database().reference().child("users").child(user)
        DB.updateChildValues(["profilePic": newProfilePic])
    }
    
    
    /*
     DateCreated
    */
    func readDateCreated(user : String, completion: @escaping (Double) -> Void) {
        DB.child(user).child("dateCreated").observeSingleEvent(of: .value) { (snapshot) in
            if let dateCreated = snapshot.value as? Double {
                completion(dateCreated)
            }
        }
    }
    
    func updateDateCreated(user : String, newDateCreated : Double) {
        let DB = Database.database().reference().child("users").child(user)
        DB.updateChildValues(["dateCreated": newDateCreated])
    }
    
    
    /*
     dateLastActive
    */
    func readDateLastActive(user : String, completion: @escaping (Double) -> Void) {
        DB.child(user).child("dateLastActive").observeSingleEvent(of: .value) { (snapshot) in
            if let dateLastActive = snapshot.value as? Double {
                completion(dateLastActive)
            }
        }
    }
    
    func updateDateLastActive(user : String, newDateLastActive : Double) -> Void {
        let DB = Database.database().reference().child("users").child(user)
        DB.updateChildValues(["dateLastActive": newDateLastActive])
    }

    
    /*
        Followers
    */
    ///reads the number of followers a given user has
    func readFollowers(user : String, completion: @escaping ([String]) -> Void) {
        DB.child(user).child("followers").observeSingleEvent(of: .value) { (snapshot) in
            if let followers = snapshot.value as? [String : String] {
                var followersList:[String] = []
                for (_,follower) in followers {
                    followersList.append(follower)
                }
                completion(followersList)
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
    func readFollowing(user : String, completion : @escaping ([String]) -> Void) {
        DB.child(user).child("followings").observeSingleEvent(of: .value) { (snapshot) in
            if let followings = snapshot.value as? [String : String] {
                var followingsList:[String] = []
                for (_,following) in followings {
                    followingsList.append(following)
                }
                completion(followingsList)
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
    func readNewContent(user : String, completion : @escaping([String]) -> Void) {
        DB.child(user).child("newContent").observeSingleEvent(of: .value) { (snapshot) in
            var links:[String] = []
            for child in snapshot.children {
                let child = child as? DataSnapshot
                guard let link = child?.value as? String else { return }
                links.append(link)
            }
            completion(links)
        }
    }
    
    
    ///adds new post links to the user's new content
    func addNewContent(user : String, link : String) {
        let updatedLink = convertStringToKey(link: link)
        DB.child(user).child("newContent").updateChildValues([updatedLink : link])
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
        let updatedLink = convertStringToKey(link: link)
        DB.child(user).child("suggestedContent").updateChildValues([updatedLink : link])
        print("wer are adding the content")
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
     Folders
    */
    //TODO the folder.toString() should be ACCURATE
    func addFolder(user : String, folder : Folder) {
        DB.child(user).child("folders").updateChildValues([folder.folderName : folder.toString()])
    }
    
    
    ///Reads only the folderNamess from the database for the given user
    func readFolders(user : String, completion : @escaping([String])-> Void) {
        DB.child(user).child("folders").observeSingleEvent(of: .value) { (snapshot) in
            if let folders = snapshot.value as? [String : Any] {
                var folderNames : [String] = []
                for folder in folders {
                    folderNames.append(folder.key)
                }
                folderNames.sort()
                completion(folderNames)
            }
        }
    }
    
    ///reads a SINGLE folder
    func readSingleFolder(user : String, folderName : String, completion : @escaping(Folder)-> Void) {
        DB.child(user).child("folders").child(folderName).observeSingleEvent(of: .value) { (snapshot) in
            if let folder = snapshot.value as? [String : Any] {
                let folderName = folder["folderName"] as! String
                let iconLink = folder["icon"] as! String
                let thisFolder = Folder(folderName: folderName, iconLink: iconLink, dateCreated: folder["dateCreated"] as! Double, dateLastModified: folder["dateLastModified"] as! Double, content: folder["content"] != nil ? folder["content"] as! [String : String] : [:] as! [String : String], numOfImages: folder["numOfImages"] as! Int, numOfVideos: folder["numOfVideos"] as! Int, isPrivate: folder["isPrivate"] as! Bool, followers: folder["followers"] != nil ? folder["followers"] as! [String] : [] as! [String], followersCount: folder["followersCount"] as! Int)
                
                completion(thisFolder)
                
            }
        }
    }
    
    
    ///reads the complete folders and puts it in the folder class
    func readCompleteFolders(user : String, completion : @escaping([Folder])-> Void) {
        DB.child(user).child("folders").observeSingleEvent(of: .value) { (snapshot) in
            if let folders = snapshot.value as? [String : Any] {
                var folderArray : [Folder] = []
                for folderKey in folders.keys {
                    let folder : [String : Any] = folders[folderKey] as! [String : Any]
                    let folderName = folder["folderName"] as! String
                    let iconLink = folder["icon"] as! String
                    let content = folder["content"] != nil ? folder["content"] as! [String : String] : [:] as! [String : String]
                    let thisFolder = Folder(folderName: folderName, iconLink: iconLink, dateCreated: folder["dateCreated"] as! Double, dateLastModified: folder["dateLastModified"] as! Double, content: content, numOfImages: folder["numOfImages"] as! Int, numOfVideos: folder["numOfVideos"] as! Int, isPrivate: folder["isPrivate"] as! Bool, followers: folder["followers"] != nil ? folder["followers"] as! [String] : [] as! [String], followersCount: folder["followersCount"] as! Int)
                    
                    folderArray.append(thisFolder)
                }
                
                //TODO sort by date created 
                folderArray.sort(by: { (folder1, folder2) -> Bool in
                    return folder1.folderName < folder2.folderName
                })
                
                completion(folderArray)
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
            folders[folder.folderName] = folder.toString()
        }
        
        DB.child(user).updateChildValues(["folders" : folders])
    }
    
    
    
    /*
    foldersFollowing
    */
    ///reads the folders the given user is following
    func readFoldersReference(user : String, completion : @escaping([FolderReference])->Void) {
        DB.child(user).child("folderReferences").observeSingleEvent(of: .value) { (snapshot) in
            if let folderReferences = snapshot.value as? [String : [String : String]] {
                var folderReferencesArray : [FolderReference] = []
                //TODO cycle through the users' names and then cycle through the folder names making a folderReference Class and adding it to the folderReferences Array along the way
                for user in folderReferences {
                    let admin = user.key
                    for folderName in folderReferences[admin]! {
                        let folderRef = FolderReference(admin: admin, folderName: folderName.key)
                        folderReferencesArray.append(folderRef)
                    }

                }
                
//                //TODO sort by date created
                folderReferencesArray.sort(by: { (folder1, folder2) -> Bool in
                    return folder1.folderName < folder2.folderName
                })
                
                completion(folderReferencesArray)
            }
        }
    }
    
    
    ///adds a folder to the folder's following list
    func addFolderReference(user : String, newFolder : FolderReference) {
        DB.child(user).child("folderReferences").child(newFolder.admin).updateChildValues([newFolder.folderName : newFolder.folderName])
    }
    
    ///Deletes a folder from the folderReferences in DB for given user
    func deleteFolderReference(user : String, folder : FolderReference) {
        DB.child(user).child("folderReferences").child(folder.admin).child(folder.folderName).removeValue()
    }
    
}
