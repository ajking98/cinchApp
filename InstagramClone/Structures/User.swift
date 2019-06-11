//
//  UserClass2.swift
//  InstagramClone


import Foundation
import UIKit


class User  {
    
    var name:String?
    var username: String?
    var email:String?
    var password:String?
    var isPrivate:Bool?
    var profilePic: UIImage?
    var folders : Folder?
    var tags : [Tag]?
    var dateCreated : Date?
    var dateLastActive : Date?
    var uuid : UUID?
    
    //default variables 
    let defaultProfilePic = UIImage(named: "profilePlaceholder")
    let folder1 = Folder(folderName: "personal")
    
    init() {
        name = ""
        email = ""
        password = ""
        isPrivate = false
        profilePic = defaultProfilePic
        uuid = UIDevice.current.identifierForVendor
        folders = folder1
        //add Random folder to user
    }
    
    //add Default image
    init(name : String, email : String, password: String, isPrivate:Bool) {
        self.name = name
        self.email = email
        self.password = password
        self.isPrivate = isPrivate
        self.profilePic = defaultProfilePic
        uuid = UIDevice.current.identifierForVendor
    }
    
    
    init(name : String, username : String, email : String, password: String, isPrivate:Bool, profilePic : UIImage) {
        self.name = name
        self.username = username
        self.email = email
        self.password = password
        self.isPrivate = isPrivate
        self.profilePic = profilePic
    }
    
    func toString() -> [String: Any] {
        let userString:[String : Any] = ["name": name, "email": email, "username": username, "password": password, "isPrivate": isPrivate, "profilePic": profilePic?.toString(), "folders": folder1.toString()]
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
