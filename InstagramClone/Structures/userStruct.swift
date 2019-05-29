//
//  userStruct.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 5/24/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct userStruct {
    let uuid:String
    var name: String
    var password: String
    var profilePic: String
    var email: String
    var privateOrPublic:Bool
    var tags:tagStruct
    let itemRef:DatabaseReference?
    
    func getName() -> String {
        return name
    }
    
    mutating func setName(newName:String) {
        name = newName
    }
    
    func getPassword() -> String {
        return password
    }
    
    mutating func setPassword(newPassword:String) {
        password = newPassword
    }
    
    func getProfilePic() -> String {
        return profilePic
    }
    
    mutating func setProfilePic(newProfilePic:String) {
        profilePic = newProfilePic
    }
    
    func getEmail() -> String {
        return email
    }
    
    mutating func setEmail(newEmail:String) {
        email = newEmail
    }
    
    func getPrivateOrPublic() -> Bool {
        return privateOrPublic
    }
    
    mutating func setPrivateOrPublic(newPrivateOrPublic:Bool) {
        privateOrPublic = newPrivateOrPublic
    }
    
    func getTagStruct() -> tagStruct {
        return tags
    }
    
    mutating func setTagStruct(newTagName:String, newTagImages:[String]) {
        tags = tagStruct(tagName: newTagName, tagImages: newTagImages)
    }
    
    init(uuid:String, name:String, password:String, email:String, profilePic:String, privateOrPublic:Bool, tags:tagStruct) {
        self.uuid = uuid
        self.name = name
        self.password = password
        self.email = email
        self.profilePic = profilePic
        self.privateOrPublic = privateOrPublic
        self.tags = tags
        self.itemRef = nil
    }
    

}
