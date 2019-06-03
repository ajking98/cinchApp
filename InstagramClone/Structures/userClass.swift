//
//  firebaseClass.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 6/1/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit

class userClass {
    var name:String
    var email:String
    var password:String
    var isPrivate:Bool
    var profilePic:String
    var user = userStruct()
    // var tag:tagClass
    

    init(name:String, email:String, password:String, isPrivate:Bool, profilePic:String) {
        self.name = name
        self.email = email
        self.password = password
        self.isPrivate = isPrivate
        self.profilePic = profilePic
    }
    
    init(name:String) {
        self.name = name
        self.email = user.email
        self.password = user.password
        self.isPrivate = user.isPrivate
        self.profilePic = user.profilePic
    }
}
