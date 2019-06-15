//
//  ParentStruct.swift
//  InstagramClone
/*
    Responsible for Creating, Reading, Updating, and Deleting users from the database
 */


import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage


struct ParentStruct {
    let DB = Database.database().reference().child("users")
    let uuid = UIDevice.current.identifierForVendor!
    //returns true if the user was successfully added
    // WORKS
    func createUser(user : User) -> Bool{
        if user.username == nil {
            //USE UUID
            let uuid = UIDevice.current.identifierForVendor!
            let location = DB.child(uuid.uuidString)
            location.setValue(user.toString())
            return true
        }
        else {
            //user username
            let location = DB.child(user.username!)
            location.setValue(user.toString())
            return true
        }
    }
    
    //Used to call a user based on username or uuid
    func readUser <T>(user : T, completion: @escaping (User, String, String, Any) -> String) {
        guard user is UUID else {
            var folderArr = [String]()
            DB.child(String(describing: user)).observeSingleEvent(of: .value) { (snapshot) -> Void in
                if let dict = snapshot.value as? [String:Any] {
                    var name:String?
                    var email: String?
                    var password: String?
                    var isPrivate: Bool?
                    var profilePic: String?
                    var dateCreated: String?
                    var dateLastActive: String?
                    var folders: Any?
                    let dictionary = snapshot.value as? NSDictionary
                    name = dictionary?["name"] as? String ?? ""
                    email = dictionary?["email"] as? String ?? ""
                    password = dictionary?["password"] as? String ?? ""
                    isPrivate = dictionary?["isPrivate"] as? Bool ?? false
                    profilePic = dictionary?["profilePic"] as? String ?? ""
                    dateCreated = dictionary?["dateCreated"] as? String ?? ""
                    dateLastActive = dictionary?["dateLastActive"] as? String ?? ""
                    folders = dictionary?["folders"]
                    UserStruct().readFolders(user: self.uuid.uuidString, readFolderClosure: {(folders:[String]) in
                        for item in folders {
                            folderArr.append(item)
                        }
                    })
                    var userInfo = User(name: name!, username: String(describing: user), email: email!, password: password!, isPrivate: isPrivate!)
                    completion(userInfo, dateCreated!, dateLastActive!, folders)
                }
            }
            return
        }
        DB.child(uuid.uuidString).observeSingleEvent(of: .value) { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                var name:String?
                var email: String?
                var password: String?
                var isPrivate: Bool?
                var profilePic: String?
                var dateCreated: String?
                var dateLastActive: String?
                var folders: Any?
                let dictionary = snapshot.value as? NSDictionary
                name = dictionary?["name"] as? String ?? ""
                email = dictionary?["email"] as? String ?? ""
                password = dictionary?["password"] as? String ?? ""
                isPrivate = dictionary?["isPrivate"] as? Bool ?? false
                profilePic = dictionary?["profilePic"] as? String ?? ""
                dateCreated = dictionary?["dateCreated"] as? String ?? ""
                dateLastActive = dictionary?["dateLastActive"] as? String ?? ""
                folders = dictionary?["folders"]
                var userInfo = User(name: name!, username: String(describing: user), email: email!, password: password!, isPrivate: isPrivate!, profilePic: (profilePic?.toImage())!)
//                userClosure(userInfo, dateCreated!, dateLastActive!, folders)
                completion(userInfo, dateCreated!, dateLastActive!, folders)
            }
        }
        return
    }

    //Used to migrate from the user's UUID to the user's username
    //Can also be used if user wishes to update their username
    //returns the updated User
    func updateUser<T>(user : T, username : String, prevUserInfo: User) -> Bool {
            guard user is UUID else {
                DB.updateChildValues([username: prevUserInfo.toString()])
                deleteUser(user: user, userInfo: prevUserInfo)
                return true
            }
            //Handle UUID
            DB.updateChildValues([username: prevUserInfo.toString()])
            deleteUser(user: user, userInfo: prevUserInfo)
            return true
    }
    
    
    //Used to remove a User permanently
    //returns true if the user was successfully deleted
    func deleteUser<T>(user : T, userInfo:User) -> User {
            guard user is UUID else {
                //Handle username
                let DB = Database.database().reference().child("users").child(String(describing: user)).removeValue()
                return User(name: userInfo.name!, username: userInfo.username!, email: userInfo.email!, password: userInfo.password!, isPrivate: userInfo.isPrivate!)
            }
            //Handle UUID
            let DB = Database.database().reference().child("users").child(uuid.uuidString).removeValue()
            return User(name: userInfo.name!, username: userInfo.username!, email: userInfo.email!, password: userInfo.password!, isPrivate: userInfo.isPrivate!)
    }
    
    
    
    
}
