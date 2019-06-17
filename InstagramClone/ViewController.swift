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

        ParentStruct().readUser(user: uuid.uuidString, completion: { (userInfo:User, dateCreated:String, dateLastActive:String, folders:Any) in
            print("printing userhh: ", userInfo)
            print("printing name: ", userInfo.name!)
            print("printing password: ", userInfo.password!)
            UserStruct().readFolders(user: self.uuid.uuidString, readFolderClosure: {(folders:[String]) in
                for item in folders {
                    print(item)
                }
                self.userDefaults.set(folders, forKey: defaultKeys.folderKey)
                self.userDefaults.set(userInfo.name!, forKey: defaultKeys.nameKey)
                self.userDefaults.set(userInfo.email!, forKey: defaultKeys.emailKey)
                self.userDefaults.set(userInfo.password!, forKey: defaultKeys.passwordKey)
                self.userDefaults.set(userInfo.isPrivate, forKey: defaultKeys.isPrivateKey)
                self.userDefaults.set(dateCreated, forKey: defaultKeys.dateCreatedKey)
                self.userDefaults.set(dateLastActive, forKey: defaultKeys.dateLastActiveKey)
            })
        })
        
        // Do any additional setup after loading the view.
        emailTextField.backgroundColor = UIColor.clear
        emailTextField.tintColor = UIColor.white
        emailTextField.textColor = UIColor.white
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white:1.0, alpha: 0.6)] as [NSAttributedString.Key: Any])
        
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: 29, width: UIScreen.main.bounds.width - 70, height: 0.6)
        bottomLayer.backgroundColor = UIColor(red: 255/255, green: 50/255, blue: 2/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(bottomLayer)
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.tintColor = UIColor.white
        passwordTextField.textColor = UIColor.white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white:1.0, alpha: 0.6)] as [NSAttributedString.Key: Any])
        
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: UIScreen.main.bounds.width - 70, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor(red: 255/255, green: 50/255, blue: 2/255, alpha: 1).cgColor
        passwordTextField.layer.addSublayer(bottomLayerPassword)
        
        
        nameTextField.backgroundColor = UIColor.clear
        nameTextField.tintColor = UIColor.white
        nameTextField.textColor = UIColor.white
        nameTextField.attributedPlaceholder = NSAttributedString(string: nameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white:1.0, alpha: 0.6)] as [NSAttributedString.Key: Any])
        
        bottomLayer.frame = CGRect(x: 0, y: 29, width: UIScreen.main.bounds.width - 70, height: 0.6)
        bottomLayer.backgroundColor = UIColor(red: 255/255, green: 50/255, blue: 2/255, alpha: 1).cgColor
        nameTextField.layer.addSublayer(bottomLayer)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func loginClickButton(_ sender: Any) {
        print("Login button clicked")
//        self.createTable()
//        self.insertUser()
//        self.listUsers()
//        getUserInfo()
        if (emailTextField.text != "" && passwordTextField.text != "" ) {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
                (user, error) in
                
                if (user != nil) {
                    print("User authenticated")
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                    // self.performSegue(withIdentifier: "homeView", sender: self)
                } else {
                    print("there was a error")
//                    self.errorLabel?.isHidden = false
                }
                
            }
        } else {
            print("there was an error")
//            self.errorLabel?.isHidden = false
        }
    }
    
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
        ParentStruct().readUser(user: uuid.uuidString, completion: { (userInfo:User, dateCreated:String, dateLastActive:String, folders:Any) in
            print("printing userhh: ", userInfo)
            print("printing name: ", userInfo.name!)
            print("printing password: ", userInfo.password!)
            let insertUser = self.usersTable.insert(self.name <- userInfo.name!, self.email <- userInfo.email!, self.password <- userInfo.password!, self.isPrivate <- userInfo.isPrivate! )
            
            do {
                try self.database.run(insertUser)
                print("Inserted User ")
            } catch {
                print(error)
            }
        })
        
        
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
        if let stringOne = self.userDefaults.string(forKey: defaultKeys.nameKey) {
            print(stringOne) // Some String Value
        }
        
        if let stringTwo = self.userDefaults.string(forKey: defaultKeys.emailKey) {
            print(stringTwo) // Some String Value
        }
        if let stringThree = self.userDefaults.string(forKey: defaultKeys.passwordKey) {
            print(stringThree) // Some String Value
        }
        if let stringFour = self.userDefaults.string(forKey: defaultKeys.isPrivateKey) {
            print(stringFour) // Some String Value
        }
        if let stringFive = self.userDefaults.string(forKey: defaultKeys.dateCreatedKey) {
            print(stringFive) // Some String Value
        }
        if let stringSix = self.userDefaults.string(forKey: defaultKeys.dateLastActiveKey) {
            print(stringSix) // Some String Value
        }
        
        let foodArray = self.userDefaults.object(forKey: defaultKeys.folderKey) as? [String] ?? [String]()
        print(foodArray.count)
        print(foodArray[0])
    }
    


}

