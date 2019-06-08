//
//  UserStruct2.swift
/*
 Stores RU commands the following variables: READ, UPDATE
    - name
    - email
    - password
    - isPrivate
    - profilePic
    - dateCreated
    - dateLastActive
 
 CRD commands for: CREATE, READ, DELETE
    - folders
    - tags
 
 
 Generic Type <T> can be either the UUID (if the user hasn't set up an account yet) or a username (if one exists)
 */

//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage


struct UserStruct {
    
    var databaseReference = Database.database().reference()
    
    /*
     Name
     */
    func readName <T>(user : T)-> String {
        guard user is UUID else {
            //Handle username
            return ""
        }
        //Handle UUID
        if let id = user.uuid {
            databaseReference.child("users").child(id.uuidString).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot.value as Any)
                        })
            { (error) in
            print(error.localizedDescription)
            }
        }
        return ""
    }
    
    
    
    //returns true if successful
    func updateName<T>(user : T, newName : String) -> Bool{
        guard user is UUID else {
            //Handle username
            return true
        }
        //Handle UUID
        return true
    }
    
    
    
    
    /*
        EMAIL
    */
    
    //returns the email address of the user
    func readEmail<T>(user : T)-> String{
        guard user is UUID else {
            //Handle username
            return ""
        }
        //Handle UUID
        return ""
    }
    
    
    //Updates the email value for the user in the database
    //returns true if successful
    func updateEmail<T>(user : T, newEmail : String)-> Bool {
        guard user is UUID else {
            //Handle username
            return true
        }
        
        //Handle UUID
        return true
    }
    
    
    /*
     Password
     */
    //returns the password (This must be secured!)
    func readPassword<T>(user : T)-> String {
        guard user is UUID else {
            //Handle username
            return ""
        }
        //Handle UUID
        return ""
    }
    
    
    //returns true if successfully updated the password
    func updatePassword<T>(user : T, newPassword : String)-> Bool {
        guard user is UUID else {
            //Handle username
            return true
        }
        //Handle UUID
        return true
    }
    
    
    
    
    /*
     isPrivate
    */
    //returns the value of isPrivate in the database
    func readIsPrivate<T>(user : T)->Bool {
        guard user is UUID else {
            //Handle username
            return true
        }
            //Handle UUID
        return true
    }
    
    
    
    //returns true if successfully changed the value in the database
    func updateIsPrivate<T>(user : T, newIsPrivate : Bool) -> Bool {
        guard user is UUID else {
            //Handle useername
            return true
        }
            //Handle UUID
        return true
    }
    
    
    
    
    /*
     ProfilePic
     */
    //returns the profile pic of the user given
    func readProfilePic<T>(user : T) -> UIImage {
        guard user is UUID else {
            //Handle username given
            return UIImage()
        }
        //Handle UUID given
            return UIImage()
    }
    
    //Returns true if successfully changed the profile picture of the user given
    func updateProfilePic<T>(user : T, newProfilePic : UIImage) ->Bool {
        guard user is UUID else {
            //Handle username given
            return true
        }
        //Handle UUID given
        return true
    }
    
    
    
    
    /*
     DateCreated
    */
    //reads the date the user first joined the platform
    func readDateCreated<T>(user : T) -> Date {
        guard user is UUID else {
            //Handle username given
            return Date()
        }
        //Handle UUID given
        return Date()
    }
    
    //Updates the date and returns true if successful
    func updateDateCreated<T>(user : T, newDateCreated : Date)-> Bool {
        guard user is UUID else {
            //Handle username given
            return true
        }
        //Handle UUID given
        return true
    }
    
    
    /*
    DateLastActive
    */
    //reads the date when the user was last seen on the platform
    func readDateLastActive<T>(user : T)->Date{
        guard user is UUID else {
            //Handle username given
            return Date()
        }
        //Handle UUID given
        return Date()
    }
    
    
    //Updates the date and returns true if successful
    func updateDateLastActive<T>(user : T, newDateLastActive : Date)-> Bool {
        guard user is UUID else {
            //Handle username given
            return true
        }
        //Handle UUID given
        return true
    }
    
    
    
    
    /*
     Folders
    */
    
    //CREATE
    //Creates a new folder under the user in the database and returns the newly added folder
    func createFolder<T>(user : T, folder : Folder) -> Folder {
        guard user is UUID else {
            //Handle username given
            return folder
        }
        //Handle UUID given
        return folder
    }
    
    
    //READ
    //returns all the folders the given user has in a folder array
    func readFolders<T>(user : T)-> [Folder] {
        guard user is UUID else {
            //Handle username given
            return []
        }
        //Handle UUID given
        return []
    }
    
    
    //Update
    //Is used to rename a folder
    func updateFolder<T>(user : T, prevFolderName : String, newFolderName : String)->Bool {
        guard user is UUID else {
            //Handle username
            return true
        }
        
        //handle UUID given
        return true
    }
    
    
    //Delete
    //Takes a user and a folder name and deletes the folder with that foldername from that user and returns the deleted folder
    func deleteFolder<T>(user : T, folderName : String) ->Folder {
        guard user is UUID else {
            //Handle username
            return Folder(folderName: "")
        }
            //Handle UUID
        return Folder(folderName: "")
    }
    
    
    
    
    
    
    
    
    
}
