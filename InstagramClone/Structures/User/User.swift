//
//  UserClass2.swift
//  InstagramClone


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
    let defaultProfilePic = UIImage(named: "userPlaceholder")
    let folder1 = Folder(folderName: "random")
    let folder2 = Folder(folderName: "reactions")

    
    
    ///should only be called when first making a user to add them to the database
    init() {
        username = "" //TODO this should not be blank, it should instead generate a generic key that doesn't exist in the DB
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
    init(name : String, username : String, email : String, password: String, isPrivate : Bool, profilePicLink : String, folders : [Folder], dateCreated : Double, dateLastActive : Double, followers : [String], followings : [String], biography : String, isDarkModeEnabled : Bool, newContent : [String], suggestedContent : [String], folderReferences : [FolderReference]) {
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
        
        
        
        let userString : [String : Any] = ["name": name, "email": email, "username": username, "password": password, "isPrivate": isPrivate, "profilePic": "https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/userImages%2FhKaBCKrdabATDWHqnWIa?alt=media&token=3c8756d0-326c-42cf-86a3-b9901797749c", "folders": foldersDict, "dateCreated": dateCreated!, "dateLastActive": dateLastActive!, "followers" : followersDict, "followings" : followingsDict, "biography" : biography, "isDarkModeEnabled" : isDarkModeEnabled, "newContent" : newContentDict, "suggestedContent" : suggestedContentDict, "folderReferences" : folderReferencesDict]
        
        return userString
    }
}



//TODO what the fuck is this Below???

extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
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
