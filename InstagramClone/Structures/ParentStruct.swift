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
    //returns User object
    func readUser<T>(user : T)-> User{
//        let uuid = UIDevice.current.identifierForVendor!
        guard user is UUID else {
            //Handle Username
//            DB.child(user as! String).observeSingleEvent(of: .value, with: { (snapshot) in
//                print(snapshot.value as Any)
//            }) { (error) in
//                print(error.localizedDescription)
//            }
            return User()
        }
        //Handle UUID
        DB.child(user as! String).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value as Any)
        }) { (error) in
            print(error.localizedDescription)
        }
        return User()
    }
    
    
    
    
    //Used to migrate from the user's UUID to the user's username
    //Can also be used if user wishes to update their username
    //returns the updated User
    func updateUser<T>(user : T, username : String)-> User {
        guard user is UUID else {
            //Handle username given
            return User()
        }
        //Handle UUID given
        return User()
    }
    
    
    
    //Used to remove a User permanently
    //returns true if the user was successfully deleted
    func deleteUser<T>(user : T) -> Bool {
        guard user is UUID else {
            //Handle Username
            return true
        }
        
        //Handle UUID
        return true
    }
    
    
    
    
}
