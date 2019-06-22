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
    var DB = Database.database().reference().child("users")
    let uuid = UIDevice.current.identifierForVendor!
    var main = ViewController();
    let username = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!

    //returns true if the user was successfully added
    func createUser(user : User) -> Void {
        //user username
        print("Creating a User...")
        let location = DB.child(user.username!)
        DB.child(user.username!).setValue(user.toString())
        print("Finished creating user...")
    }
    
    //Used to call a user based on username or uuid
    func readUser(user : String, completion: @escaping (User, String, String, Any) -> Void) {
            var folderArr = [String]()
            DB.child(user).observeSingleEvent(of: .value) { (snapshot) -> Void in
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
                    UserStruct().readFolders(user: user, readFolderClosure: {(folders:[String]) in
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
    // TODO Doesn't fully work, rigt now it deletes the old account and restarts it with a new username. Fix it.
    // https://stackoverflow.com/questions/39107274/is-it-possible-to-rename-a-key-in-the-firebase-realtime-database
    //Used to migrate from the user's default unique username to the user's own username
    //Can also be used if user wishes to update their username
    //returns the updated User
    func updateUser(oldUsername : String, newUsername : String, prevUserInfo: User) -> Bool {
        readUser(user: oldUsername) { (userInfo:User, dateCreated:String, dateLastActive:String, folders:Any) in
            self.DB.child(oldUsername).observeSingleEvent(of: .value) { (snapshot) -> Void in
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
                    
                    var userInfo = User(name: name!, username: newUsername, email: email!, password: password!, isPrivate: isPrivate!)
                    self.createUser(user: userInfo)
                    UserStruct().updateExistingProfilePic(user: newUsername, newProfilePic: profilePic!)
                    UserStruct().updateDateCreated(user: newUsername, newDateCreated: Date().toString())
                    UserStruct().updateDateLastActive(user: newUsername, newDateLastActive: Date().toString())
                    self.DB.child(newUsername).observeSingleEvent(of: .value) { (snapshot) -> Void in
                        if let dict = snapshot.value as? [String:Any] {
                            var folders2: Any?
                            folders2 = dictionary?["folders"]
                            folders2 = folders
                        }
                    }
//                    UserStruct().updateFolder(user: newUsername, prevFolderName: <#T##String#>, newFolderName: <#T##String#>, prevFolderinfo: <#T##Folder#>)
                }
            }
        }
//        DB.updateChildValues([newUsername: prevUserInfo.toString()])
//        let status = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey) ?? ""
//        print(status)
//        if status != "" {
//            UserDefaults.standard.set(newUsername, forKey: defaultsKeys.usernameKey)
//        }
        deleteUser(username: oldUsername, userInfo: prevUserInfo)
        return true
    }
    
    
    //Used to remove a User permanently
    //returns true if the user was successfully deleted
    func deleteUser(username: String , userInfo:User) -> User {
        //Handle username
        let DB = Database.database().reference().child("users").child(username).removeValue()
        return User(name: userInfo.name!, username: userInfo.username!, email: userInfo.email!, password: userInfo.password!, isPrivate: userInfo.isPrivate!)
    }
    
}
