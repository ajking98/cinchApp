//
//  UserClass2.swift
//  InstagramClone


import Foundation
import UIKit


class User2  {
    
    var name:String?
    var username: String?
    var email:String?
    var password:String?
    var isPrivate:Bool?
    var profilePic: UIImage?
    var folders : [Folder]?
    var tags : [Tag]?
    var dateCreated : Date?
    var dateLastActive : Date?
    var uuid : UUID?
    
    //default variables 
    let defaultProfilePic = UIImage(named: "profilePlaceholder")
    
    init() {
        name = ""
        email = ""
        password = ""
        isPrivate = false
        profilePic = defaultProfilePic
        uuid = UIDevice.current.identifierForVendor
        
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
    
    
}
