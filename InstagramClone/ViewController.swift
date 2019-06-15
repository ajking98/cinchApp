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

struct Helper {
    let uuid = UIDevice.current.identifierForVendor!
    var userVar = User()
    var foldersVar = [String]()
    var main = ViewController();
    
    func saveToFolder(image: UIImage) -> SpotifyActionController {
        let actionController = SpotifyActionController()
        
//        main.createTable()
        
        actionController.headerData = SpotifyHeaderData(title: "Which folder do you want to save to?", subtitle: "", image: image)
        
        if Auth.auth().currentUser != nil {
            // User is signed in.
            print("hey")
        } else {
            var date = ""
            ParentStruct().readUser(user: uuid.uuidString, completion: { (userInfo:User, dateCreated:String, dateLastActive:String, folders:Any) in
                print("printing user: ", userInfo)
                print("printing name: ", userInfo.name!)
                date = userInfo.name!
                print("printing date: ",date)
                self.main.createTable(name: userInfo.name!, email: userInfo.email!, password: userInfo.password!, isPrivate: userInfo.isPrivate!, profilePic: (userInfo.profilePic?.toString())!, dateCreated: (userInfo.dateCreated?.toString())!, dateLastActive: (userInfo.dateLastActive?.toString())!)
            })
            print("printing date: ",date)
            
        }
        
        for item in 0...5 {
            actionController.addAction(Action(ActionData(title: "Folder #\(item)", subtitle: "For Content"), style: .default, handler: { action in
                // do something useful
                //                    self.dothething();
            }))
            
        }
        
        return actionController
    }
    
    func vibrate(style : UIImpactFeedbackGenerator.FeedbackStyle){
        //medium level vibration feedback
        let vibration = UIImpactFeedbackGenerator(style: style)
        vibration.impactOccurred()
    }
    
    
    func animateIn(iconsView : UIView, zoomingImageView : UIView, keyWindow : UIWindow) {
        //Animate Inwards
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {
            zoomingImageView.frame = CGRect(x:0, y:0, width: keyWindow.frame.width * 0.95, height: (zoomingImageView.frame.height) * 0.95)
            zoomingImageView.center = keyWindow.center
            
            iconsView.isHidden = false
            keyWindow.bringSubviewToFront(iconsView)
        }, completion: { (completed: Bool) in
        })
    }
    
    
    func animateIn(zoomingImageView: UIView, keyWindow: UIWindow){
        //Animate Inwards
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {
            zoomingImageView.frame = CGRect(x:0, y:0, width: keyWindow.frame.width * 0.9, height: (zoomingImageView.frame.height) * 0.9)
            zoomingImageView.center = keyWindow.center
            
        }, completion: { (completed: Bool) in
        })
        
    }
    
    
    func animateOut(zoomingImageView : ZoomingImage, blackBackgroundView : DiscoverBackGround, startingFrame : CGRect){
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            zoomingImageView.frame = startingFrame
            blackBackgroundView.alpha = 0
        }, completion: { (completed: Bool) in
            zoomingImageView.removeFromSuperview()
            
        })
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var dbRef: DatabaseReference!
    
    var database: Connection!
    let usersTable = Table("users")
    let id = Expression<Int>("id")
    let name = Expression<String?>("name")
    let email = Expression<String?>("email")
    let password = Expression<String?>("password")
    let isPrivate = Expression<Bool?>("isPrivate")
    let profilePic = Expression<String?>("profilePic")
    let dateCreated = Expression<String?>("dateCreated")
    let dateLastActive = Expression<String?>("dateLastActive")
//    let folder = Expression<[String]?>("folders")
    
    
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
    
    func createTable(name:String, email:String, password:String, isPrivate:Bool, profilePic:String, dateCreated:String, dateLastActive:String) {
        print("Create Table")
        
        let createTable = self.usersTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.name)
            table.column(self.email, unique: true)
            table.column(self.password)
            table.column(self.isPrivate)
            table.column(self.profilePic)
            table.column(self.dateCreated)
            table.column(self.dateLastActive)
        }
        
        do {
            try self.database.run(createTable)
            print("Created Table")
        } catch {
            print(error)
        }
        
    }
    
    func insertUser(_ sender: Any) {
        let uuid = UIDevice.current.identifierForVendor!
        print("Insert User")
        let alert = UIAlertController(title: "Insert User", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "Name" }
        alert.addTextField { (tf) in tf.placeholder = "Email" }
        ParentStruct().readUser(user: uuid.uuidString, completion: { (userInfo:User, dateCreated:String, dateLastActive:String, folders:Any) in
            print("printing userhh: ", userInfo)
            print("printing name: ", userInfo.name!)
        })
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let name = alert.textFields?.first?.text,
                let email = alert.textFields?.last?.text
                else { return }
            print(name)
            print(email)
            
            let insertUser = self.usersTable.insert(self.name <- name, self.email <- email)
            
            do {
                try self.database.run(insertUser)
                print("Inserted User ")
            } catch {
                print(error)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func listUsers(_ sender: Any) {
        print("List Users")
        
        do {
            let users = try self.database.prepare(usersTable)
            for user in users {
                print("userID: \(user[self.id]), name: \(String(describing: user[self.name]!)), email: \(String(describing: user[self.email]!))" )
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
    
    func deleteUser(_ sender: Any) {
        print("Delete User")
        let alert = UIAlertController(title: "Update User", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "User ID" }
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let userIdString = alert.textFields?.first?.text,
                let userId = Int(userIdString)
                else { return }
            print(userIdString)
            
            let user = self.usersTable.filter(self.id == userId)
            let deleteUser = user.delete()
            do {
                try self.database.run(deleteUser)
            } catch {
                print(error)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    


}

