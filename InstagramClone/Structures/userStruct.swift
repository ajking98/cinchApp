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
