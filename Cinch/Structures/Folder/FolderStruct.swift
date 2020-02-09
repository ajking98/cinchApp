//
//  FolderStruct2.swift
//  Cinch
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
 */

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage


struct FolderStruct {
    
    
    let DB = Database.database().reference().child("users")
//    let uuid = UIDevice.current.identifierForVendor!
    
    
    /*
     DateCreated
    */
    
    func readDateCreated(user : String, folderName: String, completion: @escaping (String) -> Void){
        DB.child(user).child("folders").child(folderName).child("dateCreated").observeSingleEvent(of: .value) { (snapshot) in
            if let dateCreated = snapshot.value as? String {
                completion(dateCreated)
            }
        }
    }
    
    
    //Updates the dateCreated attribute in the database
    func updateDateCreated(user : String, folderName : String, newDateCreated : Date){
        let DB = Database.database().reference().child("users").child(user).child("folders").child(folderName)
        DB.updateChildValues(["dateCreated": newDateCreated.toString()])
    }
    
    
    
    /*
     DateLastModified
     */
    func readDateLastModified(user : String, folderName: String, completion: @escaping (String) -> Void){
        DB.child(user).child("folders").child(folderName).child("dateLastModified").observeSingleEvent(of: .value) { (snapshot) in
            if let dateLastModified = snapshot.value as? String {
                completion(dateLastModified)
            }
        }
    }
    
    
    //Updates the dateLastModified attribute in the database
    ///should be called once the user makes any edits on a folder
    func updateDateLastModified(user : String, folderName : String, newDateLastModified : Date) {
        let DB = Database.database().reference().child("users").child(user).child("folders").child(folderName)
        DB.updateChildValues(["dateLastModified": newDateLastModified.toString()])
    }
    
    
    
    /*
     Icon
    */
    ///gets the icon for the folder from the database
    func readIcon(user : String, folderName: String, completion: @escaping (String) -> Void){
        DB.child(user).child("folders").child(folderName).child("icon").observeSingleEvent(of: .value) { (snapshot) in
            if let icon = snapshot.value as? String {
                completion(icon)
            }
        }
    }
    
    
    ///updates the icon in the database for that given folder - Should be given a link
    func updateIcon(user : String, folderName: String, newIcon : String) {
        let DB = Database.database().reference().child("users").child(user).child("folders").child(folderName)
        DB.updateChildValues(["icon": newIcon])
    }
    
    
    
    
    /*
     numOfImages
    */
    //returns the number of Images the user has as content in that folder
    //Is helpful to the user to show some stats about each folder and helpful for us to collect data on which is more preffered (Videos or Images)
    func readNumOfImages(user : String, folderName: String, completion: @escaping (Int) -> Void) {
        DB.child(user).child("folders").child(folderName).child("numOfImages").observeSingleEvent(of: .value) { (snapshot) in
            if let numOfImages = snapshot.value as? Int {
                completion(numOfImages)
            }
        }
    }
    
    
    //updates the numOfImages value in the database and returns true if done successfully
    //should be called whenever the user uploads a new image to a selected folder
    func updateNumOfImages(user : String, folderName : String, newNumOfImages : Int) {
        let DB = Database.database().reference().child("users").child(user).child("folders").child(folderName)
        DB.updateChildValues(["numOfImages": newNumOfImages])
    }
    
    ///Updates the number of images with a given constant
    func updateNumOfImagesByConstant(user : String, folderName : String, constant : Int) {
        readNumOfImages(user: user, folderName: folderName) { (previousNumberOfImages) in
            let newNumberOfImages = previousNumberOfImages + constant
            self.DB.child(user).child("folders").child(folderName).child("numOfImages").setValue(newNumberOfImages)
        }
    }
    
    
    
    /*
     numOfVideos
    */
    //Is helpful to the user to show some stats about each folder and helpful for us to collect data on which is more preffered (Videos or Images)
    ///returns the number of Videos the user has as content in that folder
    func readNumOfVideos(user : String, folderName: String, completion: @escaping (Int) -> Void){
        DB.child(user).child("folders").child(folderName).child("numOfVideos").observeSingleEvent(of: .value, with: { (snapshot) in
            if let numOfVideos = snapshot.value as? Int {
                completion(numOfVideos)
            }
        })
    }
    
    //should be called whenever the user uploads a new video to a selected folder
    ///updates the numOfVideos value in the database and returns true if done successfully
    func updateNumOfVideos(user : String, folderName : String, newNumOfVideos : Int) {
        let DB = Database.database().reference().child("users").child(String(describing: user)).child("folders").child(folderName)
        DB.updateChildValues(["numOfVideos": newNumOfVideos])
    }
    
    ///Updates the number of videos with a given constant
    func updateNumOfVideosByConstant(user : String, folderName : String, constant : Int) {
        readNumOfVideos(user: user, folderName: folderName) { (previousNumberOfVideos) in
            let newNumberOfVideos = previousNumberOfVideos + constant
            self.DB.child(user).child("folders").child(folderName).child("numOfVideos").setValue(newNumberOfVideos)
        }
    }
    
    
    /*
     isPrivate
    */
    ///Checks the isPrivate attribute in the database
    func readIsPrivate(user : String, folderName: String, completion: @escaping (Bool) -> Void) {
        DB.child(user).child("folders").child(folderName).child("isPrivate").observeSingleEvent(of: .value, with: { (snapshot) in
            if let isPrivate = snapshot.value as? Bool {
                completion(isPrivate)
            }
        })
    }
    
    
    ///changes the value of isPrivate in the database to the given newIsPrivate boolean value
    func updateIsPrivate(user : String, folderName : String, newIsPrivate : Bool) {
        let DB = Database.database().reference().child("users").child(String(describing: user)).child("folders").child(folderName)
        DB.updateChildValues(["isPrivate": newIsPrivate])
    }
    
    
    
    /*
     Content
    */
    ///reads the folder's content
    func readContent(user : String, folderName : String, completion : @escaping([String])->Void) {
        DB.child(user).child("folders").child(folderName).child("content").observeSingleEvent(of: .value) { (snapshot) in
            var contentArray: [String] = []
            for child in snapshot.children {
                guard let child = child as? DataSnapshot else { return }
                guard let value = child.value as? String else { return }
                contentArray.append(value)
            }
                completion(contentArray)
        }
    }
    
    
    //Must be given a link representing the post within the Post's dictionary in the DB
    ///adds an extra post content to the Folder's content in DB
    func addContent(user : String, folderName : String, link : String) {
        let updatedLink = convertStringToKey(link: link)
        DB.child(user).child("folders").child(folderName).child("content").updateChildValues([updatedLink : link])

    }
    
    
    ///deletes a given post from the content's dictionary with in the Folder
    func deleteContent(user : String, folderName : String, link : String) {
        DB.child(user).child("folders").child(folderName).child("content").child(link).removeValue()
    }
    
    
    /*
     Followers
    */
    ///reads the followers list from the database for the given folder
    func readFollowers(user : String, folderName : String, completion : @escaping([String : String])->Void) {
        DB.child(user).child("folders").child(folderName).child("followers").observeSingleEvent(of: .value) { (snapshot) in
            if let followers = snapshot.value as? [String : String] {
                completion(followers)
            }
        }
    }
    
    
    ///adds a follower to the list of followers in DB
    func addFollower(user : String, folderName : String, newFollower : String) {
        DB.child(user).child("folders").child(folderName).child("followers").updateChildValues([newFollower : newFollower])
    }
    
    ///Deletes a follower from the follower's list in DB
    func deleteFollower(user : String, folderName : String, follower : String) {
        DB.child(user).child("folders").child(folderName).child("followers").child(follower).removeValue()
    }
    
    
    /*
    Followers Count
    */
    ///Reads the number of followers the given folders has
    func readFollowersCount(user : String, folderName : String, completion : @escaping(Int)->Void) {
        DB.child(user).child("folders").child(folderName).child("followersCount").observeSingleEvent(of: .value) { (snapshot) in
            if let followersCount = snapshot.value as? Int {
                completion(followersCount)
            }
        }
    }
    
    ///Updates the number of followers for the given folder
    func updateFollowersCount(user : String, folderName : String, newFollowersCount : Int) {
        DB.child(user).child("folders").child(folderName).child("followersCount").setValue(newFollowersCount)
    }
    
    ///Updates the number of followers by a set constant
    func updateFollowersCountByConstant(user : String, folderName : String, constant : Int) {
        readFollowersCount(user: user, folderName: folderName) { (FollowersCount) in
            let newFollowersCount = FollowersCount + constant
            self.DB.child(user).child("folders").child(folderName).child("followersCount").setValue(newFollowersCount)
        }
    }
    
    
}
