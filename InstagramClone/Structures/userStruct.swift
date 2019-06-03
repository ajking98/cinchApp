//
//  userStruct.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 5/24/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage

struct userStruct {
    var name: String
    var password: String
    var profilePic: String
    var email: String
    var isPrivate:Bool
    var folder:folderStruct
//    var tags:tagStruct
    let uuid = UIDevice.current.identifierForVendor?.uuidString
    
    init() {
        name = ""
        password = ""
        profilePic = ""
        email = ""
        isPrivate = false
        folder = folderStruct()
//        tags = tagStruct()
    }
    
    func readName() {
        var databaseReference: DatabaseReference!
        databaseReference = Database.database().reference()
        
        databaseReference.child("users").child(uuid!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot.value as Any)
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func updateName(newName:String) {
        let refImages = Database.database().reference().child("users").child(uuid!).child("name")
        refImages.setValue(newName)
    }
    
    func readPassword() {
        var databaseReference: DatabaseReference!
        databaseReference = Database.database().reference()
        
        databaseReference.child("users").child(uuid!).child("password").observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot.value as Any)
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func updatePassword(newPassword:String) {
        let refImages = Database.database().reference().child("users").child(uuid!).child("password")
        refImages.setValue(newPassword)
    }
    
    func readProfilePicture() {
        var databaseReference: DatabaseReference!
        databaseReference = Database.database().reference()
        
        databaseReference.child("users").child(uuid!).child("profilePic").observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot.value as Any)
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func updateProfilePic(profilePic:String) {
        let refImages = Database.database().reference().child("users").child(uuid!).child("profilePic")
        refImages.setValue(profilePic)
    }
    
    func deleteProfilePic(profilePic:String){
        let refImages = Database.database().reference().child("users").child(uuid!).child("profilePic")
        refImages.setValue("")
    }
    
    func readEmail() {
        var databaseReference: DatabaseReference!
        databaseReference = Database.database().reference()
        
        databaseReference.child("users").child(uuid!).child("email").observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot.value as Any)
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func updateEmail(newName:String) {
        let refImages = Database.database().reference().child("users").child(uuid!).child("email")
        refImages.setValue(newName)
    }

    func readFolderPrivacy() {
        var databaseReference: DatabaseReference!
        databaseReference = Database.database().reference()
        
        databaseReference.child("users").child(uuid!).child("private").observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot.value as Any)
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func updateFolderPrivacy(isPrivate:Bool) {
        let refImages = Database.database().reference().child("users").child(uuid!).child("private")
        refImages.setValue(isPrivate)
    }
    
}
