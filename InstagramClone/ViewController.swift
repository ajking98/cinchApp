//
//  ViewController.swift
//  InstagramClone
//
//  Created by Gedi, Ahmed M on 4/11/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import XLActionController
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SQLite

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var dbRef: DatabaseReference!
    let uuid = UIDevice.current.identifierForVendor!
    
    var database: Connection!
    let usersTable = Table("users")
    let id = Expression<Int>("id")
    let name = Expression<String?>("name")
    let email = Expression<String?>("email")
    let password = Expression<String?>("password")
    let isPrivate = Expression<Bool?>("isPrivate")
//    let profilePic = Expression<String?>("profilePic")
//    let dateCreated = Expression<String?>("dateCreated")
//    let dateLastActive = Expression<String?>("dateLastActive")
//    let folder = Expression<[String]?>("folders")
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // Creates Table
    func createTable() {
        print("Create Table")
        
        let createTable = self.usersTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.name)
            table.column(self.email)
            table.column(self.password)
            table.column(self.isPrivate)
            //            table.column(self.profilePic)
            //            table.column(self.dateCreated)
            //            table.column(self.dateLastActive)
        }
        
        do {
            try self.database.run(createTable)
            print("Created Table")
        } catch {
            print(error)
        }
        
    }
    
    func insertUser() {
        print("Insert User")
        
    }
    
    
    func listUsers() {
        print("List Users")
        do {
            let users = try self.database.prepare(usersTable)
            for user in users {
                print("userID: \(user[self.id]), name: \(String(describing: user[self.name]!)), email: \(String(describing: user[self.email]!)), password: \(String(describing: user[self.password]!)), isPrivate: \(String(describing: user[self.isPrivate]!))" )
            }
        } catch {
            print(error)
        }
    }
    
    func updateUser(_ sender: Any) {
        print("Update User")
        let alert = UIAlertController(title: "Update User", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "User ID" }
        alert.addTextField { (tf) in tf.placeholder = "Email" }
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let userIdString = alert.textFields?.first?.text,
                let userId = Int(userIdString),
                let email = alert.textFields?.last?.text
                else { return }
            print(userIdString)
            print(email)
            
            let user = self.usersTable.filter(self.id == userId)
            let updateUser = user.update(self.email <- email)
            do {
                try self.database.run(updateUser)
            } catch {
                print(error)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func deleteUser(userId:Int) {
        print("Delete User")
        let user = self.usersTable.filter(self.id == userId)
        let deleteUser = user.delete()
        do {
            try self.database.run(deleteUser)
        } catch {
            print(error)
        }
    }
    
    func getUserInfo() {
        if let stringOne = self.userDefaults.string(forKey: defaultsKeys.nameKey) {
            print(stringOne) // Some String Value
        }
        
        if let stringTwo = self.userDefaults.string(forKey: defaultsKeys.emailKey) {
            print(stringTwo) // Some String Value
        }
        if let stringThree = self.userDefaults.string(forKey: defaultsKeys.passwordKey) {
            print(stringThree) // Some String Value
        }
        if let stringFour = self.userDefaults.string(forKey: defaultsKeys.isPrivateKey) {
            print(stringFour) // Some String Value
        }
        if let stringFive = self.userDefaults.string(forKey: defaultsKeys.dateCreatedKey) {
            print(stringFive) // Some String Value
        }
        if let stringSix = self.userDefaults.string(forKey: defaultsKeys.dateLastActiveKey) {
            print(stringSix) // Some String Value
        }
        
        let foodArray = self.userDefaults.object(forKey: defaultsKeys.folderKey) as? [String] ?? [String]()
        print(foodArray.count)
        print(foodArray[0])
    }
    


}

