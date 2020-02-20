//
//  defualtKeys.swift
//  Cards
//
//  Created by Ahmed Gedi on 6/16/19.
//

import Foundation

struct defaultsKeys {
    static var usernameKey = "usernameKey"
    static var profileCreatedKey = "profileCreatedKey"
    static let nameKey = "nameKey"
    static let emailKey = "emailKey"
    static let passwordKey = "passwordKey"
    static let isPrivateKey = "isPrivateKey"
    static let profilePicKey = "profilePicKey"
    static let dateCreatedKey = "dateCreatedKey"
    static let dateLastActiveKey = "dateLastActiveKey"
    static let otherProfile = "otherProfile" //keeps track of the profile the user is looking at
    static let typeOfUser = "typeOfUser" //either user with uniquely generated string or not
    static let stateOfUser = "stateOfUser" //user login status
    
    
    //Share extension
    ///Key for the last folder that the user has added to
    static let lastUsedFolder = "LastUsedFolder"
}
