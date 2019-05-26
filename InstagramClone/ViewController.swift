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
        print(uuid!)
        let name = nameTextField.text
        var password = "empty"
        var profilePic = "imageUrl"
        var privateOrPublic = false
        var tagName = ["imageUrl1", "imageUrl2"]
        var tag = "tag1"
        var tags = [tag: tagName]
        var personalImages = ["imageUrl", "imageUrl"]
        var numOfImages = 6
        var numOfVideos = 7
        var folderNames = ["personal", "funny", "for family"]
        var folderName:[String : Any] = ["icon": "imageUrl", "# of images": 6, "# of videos":8, "private": false, "date_created": "timeStamp", "date_modified": "timeStamp", "personalImages": personalImages]
        var timestamp = NSDate().timeIntervalSince1970
        var userData:[String : Any] = ["name": name, "password": password, "profilePic": profilePic, "private": privateOrPublic, "tags": tags, "folders": [folderNames[0]: ["icon": "iconUrl", "numOfImg": numOfImages, "numOfVids": numOfVideos, "private": privateOrPublic, "dateCreated": timestamp, "dateModified": timestamp, "images": personalImages] ]]
        print(userData)
        print(dbRef)
        print(idPath)
        
    }
    
    //TODO: Make into Struct or API
    
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

