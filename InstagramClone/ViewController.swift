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
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailTextField.backgroundColor = UIColor.clear
        emailTextField.tintColor = UIColor.white
        emailTextField.textColor = UIColor.white
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white:1.0, alpha: 0.6)] as [NSAttributedString.Key: Any])
        
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(bottomLayer)
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.tintColor = UIColor.white
        passwordTextField.textColor = UIColor.white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(white:1.0, alpha: 0.6)] as [NSAttributedString.Key: Any])
        
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        passwordTextField.layer.addSublayer(bottomLayerPassword)
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
                    self.performSegue(withIdentifier: "homeView", sender: self)
                } else {
                    print("there was a error")
                    self.errorLabel?.isHidden = false
                }
                
            }
        } else {
            print("there was an error")
            self.errorLabel?.isHidden = false
        }
    }
    


}

