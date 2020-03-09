//
//  ParentStruct.swift
//  Cinch
/*
    Responsible for Creating, Reading, Updating, and Deleting users from the database
 */


import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage


struct ParentStruct {
    let DB = Database.database().reference().child("users")
    /*
     version
     */
    func readVersion(completion: @escaping(Double)-> Void) {
        let DB2 = Database.database().reference().child("version")
        DB2.observeSingleEvent(of: .value) { (snapshot) in
            print("working: for the version: ", snapshot)
            guard let latestVersion = snapshot.value as? Double else { return }
            completion(latestVersion)
        }
    }
        
        
    
    /*
     addUser
    */
    //todo this adds the name, it should instead asign the user to an ID 
    func addUser(user : User) {
        DB.child(user.username).setValue(user.toString())
    }
    
    
    /*
     deleteUser
    */
    func deleteUser(user : String) {
        DB.child(user).removeValue()
    }
    
    
    /*
     readUser
    */
    func readUser(user : String, completion : @escaping(User)-> Void) {
        DB.child(user).observeSingleEvent(of: .value) { (snapshot) in
            if let userDict = snapshot.value as? [String : Any] {
                UserStruct().readCompleteFolders(user: user, completion: { (folders) in
                    
                    //Calling Values from the user dictionary
                    let name = userDict["name"] as! String
                    let username = userDict["username"] as! String
                    let email = userDict["email"] as! String
                    let password = userDict["password"] as! String
                    let isPrivate = userDict["isPrivate"] as! Bool
                    let profilePicLink = userDict["profilePic"] as! String
                    //folders being read through UserStruct()
                    let dateCreated = userDict["dateCreated"] as! Double
                    let dateLastActive = userDict["dateLastActive"] as! Double
                    
                    //followers
                    let followersDict = (userDict["followers"] != nil) ? userDict["followers"] as! [String : String] : [ : ] as! [String : String]
                    let followers : [String] = Array(followersDict.keys)
                    
                    //followings
                    let followingsDict = userDict["followings"] != nil ? userDict["followings"] as! [String : String] : [:] as! [String : String]
                    let followings : [String] = Array(followingsDict.keys)
                    
                    let biography = userDict["biography"] as! String
                    let isDarkModeEnabled = userDict["isDarkModeEnabled"] as! Bool
                    
                    //newContent
                    let newContentDict = userDict["newContent"] != nil ? userDict["newContent"] as! [String : String] : [:] as! [String : String]
                    let newContent : [String] = Array(newContentDict.keys)
                    
                    //suggestedContent
                    let suggestedContentDict = userDict["suggestedContent"] != nil ? userDict["suggestedContent"] as! [String : String] : [:] as! [String : String]
                    let suggestedContent : [String] = Array(suggestedContentDict.keys)
                    
                    //folderReferences
                    let folderReferencesDict = userDict["folderReferences"] != nil ? userDict["folderReferences"] as! [String : [String : String]] : [ "" : ["" : ""]]
                    var folderReferences : [FolderReference] = []
                    
                    //for loop to retreive folderReferences
                    for admin in folderReferencesDict.keys {
                        for folderName in folderReferencesDict[admin]!.keys {
                            folderReferences.append(FolderReference(admin: admin, folderName: folderName))
                        }
                    }
                    
                    let thisUser = User(name: name, username: username, email: email, password: password, isPrivate: isPrivate, profilePicLink: profilePicLink, folders: folders, followers: followers, followings: followings, biography: biography, isDarkModeEnabled: isDarkModeEnabled, newContent: newContent, suggestedContent: suggestedContent, folderReferences: folderReferences)
                    
                    completion(thisUser)
                })
            }
        }
    }
    
    
}
