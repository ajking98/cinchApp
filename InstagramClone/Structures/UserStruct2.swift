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
    let DB = Database.database().reference().child("users")
    let uuid = UIDevice.current.identifierForVendor!
    
    /*
     Name
     */
    func printVal(val:String) -> String {
        print("Hey there, \(val)")
        return val
    }
    
    func readName <T>(user : T) -> Void {
        guard user is UUID else {
            DB.child(String(describing: user)).observeSingleEvent(of: .value) { (snapshot) -> Void in
                if let dict = snapshot.value as? [String:Any] {
                    var name:String?
                    let value = snapshot.value as? NSDictionary
                    name = value?["name"] as? String ?? ""
//                    nameClosure(name!)
                    self.printVal(val: name!)
                    
                }
            }
            return
        }
//        DB.child(uuid.uuidString).observeSingleEvent(of: .value) { (snapshot) -> Void in
//            if let dict = snapshot.value as? [String:Any] {
//                var name:String?
//                let value = snapshot.value as? NSDictionary
//                name = value?["name"] as? String ?? ""
//                nameClosure(name!)
//            }
//        }
//        return
    }
    
    //returns true if successful
    func updateName<T>(user : T, newName : String) -> Bool{
        guard user is UUID else {
            //Handle username
            let DB = Database.database().reference().child("users").child(String(describing: user))
            DB.updateChildValues(["name": newName])
            return true
        }
        //Handle UUID
        let DB = Database.database().reference().child("users").child(uuid.uuidString)
        DB.updateChildValues(["name": newName])
        return true
    }
    
    /*
        EMAIL
    */
    
    //returns the email address of the user
    func readEmail <T>(user : T, emailClosure: @escaping (String) -> Void) -> Void {
        guard user is UUID else {
            DB.child(String(describing: user)).observeSingleEvent(of: .value) { (snapshot) -> Void in
                if let dict = snapshot.value as? [String:Any] {
                    var email:String?
                    let value = snapshot.value as? NSDictionary
                    email = value?["email"] as? String ?? ""
                    emailClosure(email!)
                }
            }
            return
        }
        DB.child(uuid.uuidString).observeSingleEvent(of: .value) { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                var email:String?
                let value = snapshot.value as? NSDictionary
                email = value?["email"] as? String ?? ""
                emailClosure(email!)
            }
        }
        return
    }
    
    
    //Updates the email value for the user in the database
    //returns true if successful
    func updateEmail<T>(user : T, newEmail : String)-> Bool {
        guard user is UUID else {
            //Handle username
            let DB = Database.database().reference().child("users").child(String(describing: user))
            DB.updateChildValues(["email": newEmail])
            return true
        }
        //Handle UUID
        let DB = Database.database().reference().child("users").child(uuid.uuidString)
        DB.updateChildValues(["email": newEmail])
        return true
    }
    
    
    /*
     Password
     */
    //returns the password (This must be secured!)
    func readPassword <T>(user : T, passwordClosure: @escaping (String) -> Void) -> Void {
        guard user is UUID else {
            DB.child(String(describing: user)).observeSingleEvent(of: .value) { (snapshot) -> Void in
                if let dict = snapshot.value as? [String:Any] {
                    var password:String?
                    let value = snapshot.value as? NSDictionary
                    password = value?["password"] as? String ?? ""
                    passwordClosure(password!)
                }
            }
            return
        }
        DB.child(uuid.uuidString).observeSingleEvent(of: .value) { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                var password:String?
                let value = snapshot.value as? NSDictionary
                password = value?["password"] as? String ?? ""
                passwordClosure(password!)
            }
        }
        return
    }
    
    
    //returns true if successfully updated the password
    func updatePassword<T>(user : T, newPassword : String)-> Bool {
        guard user is UUID else {
            //Handle username
            let DB = Database.database().reference().child("users").child(String(describing: user))
            DB.updateChildValues(["password": newPassword])
            return true
        }
        //Handle UUID
        let DB = Database.database().reference().child("users").child(uuid.uuidString)
        DB.updateChildValues(["password": newPassword])
        return true
    }
    
    
    
    
    /*
     isPrivate
    */
    //returns the value of isPrivate in the database
    func readPrivate <T>(user : T, privateClosure: @escaping (Bool) -> Void) -> Void {
        guard user is UUID else {
            DB.child(String(describing: user)).observeSingleEvent(of: .value) { (snapshot) -> Void in
                if let dict = snapshot.value as? [String:Any] {
                    var isPrivate:Bool?
                    let value = snapshot.value as? NSDictionary
                    isPrivate = value?["isPrivate"] as? Bool ?? false
                    privateClosure(isPrivate!)
                }
            }
            return
        }
        DB.child(uuid.uuidString).observeSingleEvent(of: .value) { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                var isPrivate:Bool?
                let value = snapshot.value as? NSDictionary
                isPrivate = value?["isPrivate"] as? Bool ?? false
                privateClosure(isPrivate!)
            }
        }
        return
    }
    
    
    
    //returns true if successfully changed the value in the database
    func updateIsPrivate<T>(user : T, newIsPrivate : Bool) -> Bool {
        guard user is UUID else {
            //Handle username
            let DB = Database.database().reference().child("users").child(String(describing: user))
            DB.updateChildValues(["isPrivate": newIsPrivate])
            return true
        }
        //Handle UUID
        let DB = Database.database().reference().child("users").child(uuid.uuidString)
        DB.updateChildValues(["isPrivate": newIsPrivate])
        return true
    }
    
    
    
    
    /*
     ProfilePic
     */
    //returns the profile pic of the user given
    func readProfilePic <T>(user : T, profilePicClosure: @escaping (String) -> Void) -> Void {
        guard user is UUID else {
            DB.child(String(describing: user)).observeSingleEvent(of: .value) { (snapshot) -> Void in
                if let dict = snapshot.value as? [String:Any] {
                    var profilePic:String?
                    let value = snapshot.value as? NSDictionary
                    profilePic = value?["profilePic"] as? String ?? ""
                    profilePicClosure(profilePic!)
                }
            }
            return
        }
        DB.child(uuid.uuidString).observeSingleEvent(of: .value) { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                var profilePic:String?
                let value = snapshot.value as? NSDictionary
                profilePic = value?["profilePic"] as? String ?? ""
                profilePicClosure(profilePic!)
            }
        }
        return
    }
    
    //Returns true if successfully changed the profile picture of the user given
    func updateProfilePic<T>(user : T, newProfilePic : UIImage) ->Bool {
        var result = newProfilePic.toString()
        guard user is UUID else {
            //Handle username
            let DB = Database.database().reference().child("users").child(String(describing: user))
            DB.updateChildValues(["profilePic": result!])
            return true
        }
        //Handle UUID
        let DB = Database.database().reference().child("users").child(uuid.uuidString)
        DB.updateChildValues(["profilePic": result!])
        return true
    }
    
    // TODO
    //Method overloading for existing images in storage because we dont want duplicates 
    func updateProfilePic<T>(user : T, newProfilePic : String) ->Bool {
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
    func readDateCreated <T>(user : T, dateCreatedClosure: @escaping (String) -> Void) -> Void {
        guard user is UUID else {
            DB.child(String(describing: user)).observeSingleEvent(of: .value) { (snapshot) -> Void in
                if let dict = snapshot.value as? [String:Any] {
                    var dateCreated:String?
                    let value = snapshot.value as? NSDictionary
                    dateCreated = value?["dateCreated"] as? String ?? ""
                    dateCreatedClosure(dateCreated!)
                }
            }
            return
        }
        DB.child(uuid.uuidString).observeSingleEvent(of: .value) { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                var dateCreated:String?
                let value = snapshot.value as? NSDictionary
                dateCreated = value?["dateCreated"] as? String ?? ""
                dateCreatedClosure(dateCreated!)
            }
        }
        return
    }
    
    //Updates the date and returns true if successful
    func updateDateCreated<T>(user : T, newDateCreated : Date)-> Bool {
        var result = newDateCreated.toString()
        guard user is UUID else {
            //Handle username
            let DB = Database.database().reference().child("users").child(String(describing: user))
            DB.updateChildValues(["dateCreated": result])
            return true
        }
        //Handle UUID
        let DB = Database.database().reference().child("users").child(uuid.uuidString)
        DB.updateChildValues(["dateCreated": result])
        return true
    }
    
    
    /*
    DateLastActive
    */
    //reads the date when the user was last seen on the platform
    func readDateLastActive <T>(user : T, dateLastActiveClosure: @escaping (String) -> Void) -> Void {
        guard user is UUID else {
            DB.child(String(describing: user)).observeSingleEvent(of: .value) { (snapshot) -> Void in
                if let dict = snapshot.value as? [String:Any] {
                    var dateLastActive:String?
                    let value = snapshot.value as? NSDictionary
                    dateLastActive = value?["dateLastActive"] as? String ?? ""
                    dateLastActiveClosure(dateLastActive!)
                }
            }
            return
        }
        DB.child(uuid.uuidString).observeSingleEvent(of: .value) { (snapshot) -> Void in
            if let dict = snapshot.value as? [String:Any] {
                var dateLastActive:String?
                let value = snapshot.value as? NSDictionary
                dateLastActive = value?["dateLastActive"] as? String ?? ""
                dateLastActiveClosure(dateLastActive!)
            }
        }
        return
    }
    
    
    //Updates the date and returns true if successful
    func updateDateLastActive<T>(user : T, newDateLastActive : Date)-> Bool {
        var result = newDateLastActive.toString()
        guard user is UUID else {
            //Handle username
            let DB = Database.database().reference().child("users").child(String(describing: user))
            DB.updateChildValues(["dateCreated": result])
            return true
        }
        //Handle UUID
        let DB = Database.database().reference().child("users").child(uuid.uuidString)
        DB.updateChildValues(["dateCreated": result])
        return true
    }
    
    
    
    
    /*
     Folders
    */
    //CREATE
    //Creates a new folder under the user in the database and returns the newly added folder
    func createFolder<T>(user : T, folder : Folder) -> Bool {
        guard user is UUID else {
            //USE username
            let uuid = UIDevice.current.identifierForVendor!
            let location = DB.child(String(describing: user)).child("folders").child(folder.folderName!)
            location.updateChildValues(folder.toString())
            return true
        }
            //user uuid
            let location = DB.child(uuid.uuidString).child("folders").child(folder.folderName!)
            location.setValue(folder.toString())
            return true
    }
    
    //READ
    //returns all the folders the given user has in a folder array
    func readFolders<T>(user : T, readFolderClosure: @escaping ([String]) -> Void) -> Void {
        guard user is UUID else {
            DB.child(String(describing: user)).child("folders").observeSingleEvent(of: .value) { (snapshot) -> Void in
                var folder = [String]()
                for folders in snapshot.children {
                    folder.append(((folders as AnyObject).key))
                }
                readFolderClosure(folder)
            }
            return
        }
        DB.child(uuid.uuidString).child("folders").observeSingleEvent(of: .value) { (snapshot) -> Void in
            var folder = [String]()
            for folders in snapshot.children {
                folder.append(((folders as AnyObject).key))
            }
            readFolderClosure(folder)
        }
        return
    }
    
    //Update
    //Is used to rename a folder
    func updateFolder<T>(user : T, prevFolderName: String, newFolderName: String, prevFolderinfo: Folder) -> Bool {
        guard user is UUID else {
            DB.child(String(describing: user)).child("folders").updateChildValues([newFolderName: prevFolderinfo.toString()])
            deleteFolder(user: String(describing: user), folderName: prevFolderName)
            return true
        }
        //Handle UUID
        DB.child(uuid.uuidString).child("folders").updateChildValues([newFolderName: prevFolderinfo.toString()])
        deleteFolder(user: String(describing: user), folderName: prevFolderName)
        return true
    }
    
    //Delete
    //Takes a user and a folder name and deletes the folder with that foldername from that user and returns the deleted folder
    func deleteFolder<T>(user : T, folderName : String) ->Folder {
        guard user is UUID else {
            //Handle username
            let DB = Database.database().reference().child("users").child(String(describing: user)).child("folders").child(folderName).removeValue()
            return Folder(folderName: folderName)
        }
        //Handle UUID
        let DB = Database.database().reference().child("users").child(String(describing: user)).child("folders").child(folderName).removeValue()
        return Folder(folderName: folderName)
    }
    
}
