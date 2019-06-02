//
//  ViewController.swift
//  InstagramClone
//
//  Created by Gedi, Ahmed M on 4/11/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var dbRef: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        
        let dbRef = Database.database().reference().child("users")
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        let idPath = dbRef.child(uuid!)
        // Create Tag Object
        var tagImages = ["imageUrl1", "imageUrl2"]
        var tagImages2 = ["imageUrl3", "imageUrl4"]
        var tags = tagStruct(tagName: "friends", tagImages: tagImages)
        var tags2 = tagStruct(tagName: "dogs", tagImages: tagImages2)
        // Create User Object
        var user = userStruct(uuid: uuid!, name: nameTextField.text!, password: "password", email: "email", profilePic: "url", privateOrPublic: false, tags: tags)
        // Create User's Folder Object
        var personalImages = ["imageUrl", "imageUrl"]
        var personalVideos = ["videoUrl", "videoUrl"]
        let folder = folderStruct(folderName: "personal", iconImage: "iconUrl", numOfImages: 7, numOfVideos: 6, privateOrPublic: false, dateCreated: "timestamp", dateModified: "timestamp", imgs: personalImages, videos: personalVideos)
        // Create Collected User Data
        var userData:[String : Any] = ["name": user.name, "password": user.password, "email": user.email, "profilePic": user.profilePic, "private": user.privateOrPublic, "tags": [tags.tagName: tagImages, tags2.tagName: tagImages2], "folders": [folder.folderName: ["icon": folder.iconImage, "numOfImg": folder.numOfImages, "numOfVids": folder.numOfVideos, "private": folder.privateOrPublic, "dateCreated": folder.dateCreated, "dateModified": folder.dateModified, "images": [ "url": folder.imgs ], "videos": folder.videos] ]]
        // See Userdata in console
        print(userData)
        // Add User data to firebase database
        idPath.setValue(userData)
        
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
    


}

