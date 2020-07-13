//
//  UserClass2.swift
//  Cinch


import Foundation
import UIKit


class User  {
    static var sharedInstance: String!
    var name:String = ""
    var username: String = ""
    var email:String = ""
    var password:String = ""
    var isPrivate:Bool = false
    var profilePic: UIImage?
    var folders : [Folder] = []
    var tags : [Tag]?
    var dateCreated : TimeInterval?
    var dateLastActive : TimeInterval?
    
    //New stuff
    var followers : [String] = []
    var followings : [String] = [] //is a dictionary of following (people) and following (folders)
    var biography : String = ""
    var isDarkModeEnabled : Bool = false
    var newContent : [String] = []
    var suggestedContent : [String] = []
    var folderReferences : [FolderReference] = []
    var profilePicLink : String?
    
    //default variables 
    let defaultProfilePic = UIImage(named: "defaultProfilePic1")
    let folder1 = Folder(folderName: "Uploaded")
    let folder2 = Folder(folderName: "Hearted")

    
    func generateUserID() -> String {
        let letters : NSString = "asdfghjkloiuytrewqazxcvbnmWERTYUIASDFGHJKXCVBN=(&^+@%!-_*)"
        let len = UInt32(letters.length)
        
        var randomString = ""
        for _ in 0 ..< 10 {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    
    
    
    ///should only be called when first making a user to add them to the database
    init() {
        username = generateUserID()
        name = ""
        email = ""
        password = ""
        isPrivate = false
        profilePic = defaultProfilePic
        folders = [folder1, folder2]
        dateCreated = Date().timeIntervalSince1970
        dateLastActive = Date().timeIntervalSince1970
    }
    
    
    init(username : String) {
        self.name = ""
        self.email = ""
        self.username = username
        self.password = ""
        self.isPrivate = false
        self.profilePic = defaultProfilePic
        folders = [folder1, folder2]
        self.dateCreated = Date().timeIntervalSince1970
        self.dateLastActive = Date().timeIntervalSince1970
    }
    
    //add Default image
    init(name : String, username : String, email : String, password: String, isPrivate:Bool) {
        self.name = name
        self.email = email
        self.username = username
        self.password = password
        self.isPrivate = isPrivate
        self.profilePic = defaultProfilePic
        self.dateCreated = Date().timeIntervalSince1970
        self.dateLastActive = Date().timeIntervalSince1970
    }
    
    
    ///Called when all the data is available
    init(name : String, username : String, email : String, password: String, isPrivate : Bool, profilePicLink : String, folders : [Folder], followers : [String], followings : [String], biography : String, isDarkModeEnabled : Bool, newContent : [String], suggestedContent : [String], folderReferences : [FolderReference]) {
        self.name = name
        self.username = username
        self.email = email
        self.password = password
        self.isPrivate = isPrivate
        self.profilePicLink = profilePicLink
        self.folders = folders
        self.dateCreated = Date().timeIntervalSince1970
        self.dateLastActive = Date().timeIntervalSince1970
        self.followers = followers
        self.followings = followings
        self.biography = biography
        self.isDarkModeEnabled = isDarkModeEnabled
        self.newContent = newContent
        self.suggestedContent = suggestedContent
        self.folderReferences = folderReferences
    }
    
    
    
    
    func toString() -> [String: Any] {
        var followersDict :[String : String] = [:]
        var followingsDict :[String : String] = [:]
        var newContentDict : [String : String] = [:]
        var suggestedContentDict : [String : String] = [:]
        var foldersDict : [String : Any] = [:]
        var folderReferencesDict : [String : Any] = [:]
        
        for follower in followers {
            followersDict[follower] = follower
        }
        for following in followings {
            followingsDict[following] = following
        }
        
        for content in newContent {
            newContentDict[content] = content
        }
        
        for content in suggestedContent {
            suggestedContentDict[content] = content
        }
        
        if folders.count < 1 {
            folders = [folder1, folder2]
        }
        
        for folder in folders {
            foldersDict[folder.folderName] = folder.toString()
        }
        
        for folderRef in folderReferences {
            folderReferencesDict[folderRef.admin] = [folderRef.folderName : folderRef.folderName]
        }
        
        
        
        let userString : [String : Any] = ["name": name, "email": email, "username": username, "password": password, "isPrivate": isPrivate, "profilePic": "https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/defaultProfilePics%2FdefaultProfilePic1.png?alt=media&token=b343a31f-15d9-42dd-9ad4-464196fdd270", "folders": foldersDict, "dateCreated": dateCreated!, "dateLastActive": dateLastActive!, "followers" : followersDict, "followings" : followingsDict, "biography" : biography, "isDarkModeEnabled" : isDarkModeEnabled, "newContent" : newContentDict, "suggestedContent" : suggestedContentDict, "folderReferences" : folderReferencesDict]
        
        return userString
    }
}

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        let myString = formatter.string(from: Date())
        return myString
    }
}
