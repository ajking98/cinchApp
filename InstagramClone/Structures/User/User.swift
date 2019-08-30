//
//  UserClass2.swift
//  InstagramClone


import Foundation
import UIKit


class User  {
    static var sharedInstance: String!
    var name:String?
    var username: String?
    var email:String?
    var password:String?
    var isPrivate:Bool?
    var profilePic: UIImage?
    var folders : [String : [String : Any]]?
    var tags : [Tag]?
    var dateCreated : Date?
    var dateLastActive : Date?
    var uuid : UUID?
    
    //New stuff
    var followers : [String] = []
    var followings : [String] = [] //is a dictionary of following (people) and following (folders)
    var biography : String = ""
    var isDarkModeEnabled : Bool = false
    var newContent : [String] = []
    var suggestedContent : [String] = []
    var foldersFollowing : [String : Any] = [:]
    
    //default variables 
    let defaultProfilePic = UIImage(named: "userPlaceholder")
    let folder1 = Folder(folderName: "random")
    let folder2 = Folder(folderName: "reactions")
    
    init() {
        name = ""
        email = ""
        password = ""
        isPrivate = false
        profilePic = defaultProfilePic
        folders = [folder1.folderName : folder1.toString(), folder2.folderName : folder2.toString()] as! [String : [String : Any]] 
        dateCreated = Date()
        dateLastActive = Date()
    }
    
    
    init(username : String) {
        self.name = ""
        self.email = ""
        self.username = username
        self.password = ""
        self.isPrivate = false
        self.profilePic = defaultProfilePic
        folders = [folder1.folderName : folder1.toString(), folder2.folderName : folder2.toString()] as! [String : [String : Any]]
        self.dateCreated = Date()
        self.dateLastActive = Date()
    }
    
    
    //add Default image
    init(name : String, username : String, email : String, password: String, isPrivate:Bool) {
        self.name = name
        self.email = email
        self.username = username
        self.password = password
        self.isPrivate = isPrivate
        self.profilePic = defaultProfilePic
        uuid = UIDevice.current.identifierForVendor
        self.dateCreated = Date()
        self.dateLastActive = Date()
    }
    
    
    init(name : String, username : String, email : String, password: String, isPrivate:Bool, profilePic : UIImage) {
        self.name = name
        self.username = username
        self.email = email
        self.password = password
        self.isPrivate = isPrivate
        self.profilePic = profilePic
        self.dateCreated = Date()
        self.dateLastActive = Date()
    }
    
    init(name : String, email : String, password: String, isPrivate:Bool, profilePic : UIImage) {
        self.name = name
        self.email = email
        self.password = password
        self.isPrivate = isPrivate
        self.profilePic = profilePic
        self.dateCreated = Date()
        self.dateLastActive = Date()
    }
    
    func toString() -> [String: Any] {
        var followersDict :[String : String] = [:]
        var followingsDict :[String : String] = [:]
        var newContentDict : [String : String] = [:]
        var suggestedContentDict : [String : String] = [:]
        
        
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
        
        
        
        
        let userString : [String : Any] = ["name": name, "email": email, "username": username, "password": password, "isPrivate": isPrivate, "profilePic": "https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/userImages%2FhKaBCKrdabATDWHqnWIa?alt=media&token=3c8756d0-326c-42cf-86a3-b9901797749c", "folders": folders, "dateCreated": dateCreated?.toString(), "dateLastActive": dateLastActive?.toString(), "followers" : followersDict, "followings" : followingsDict, "biography" : biography, "isDarkModeEnabled" : isDarkModeEnabled, "newContent" : newContentDict, "suggestedContent" : suggestedContentDict]
        return userString

    }
}

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
