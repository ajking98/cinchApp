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
    
    
    //returns true if the user was successfully added
    func createUser(user : User2) -> Bool {
        
        return true
    }
    
    
    
    //Used to call a user based on username or uuid
    //returns User object
    func readUser<T>(user : T)-> User2{
        guard user is UUID else {
            
            //Handle Username
            return User2()
        }
        //Handle UUID
        return User2()
    }
    
    
    
    
    //Used to migrate from the user's UUID to the user's username
    //Can also be used if user wishes to update their ussername 
    //returns the updated User
    func updateUser<T>(user : T, username : String)-> User2{
        guard user is UUID else {
            //Handle username given
            return User2()
        }
        //Handle UUID given
        return User2()
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
