//
//  SignUpViewController.swift
//  Cinch
//
//  Created by Ahmed Gedi on 11/30/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var cancelLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        buildGestures()
        underline()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        emailText.delegate = self
        passwordText.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    @IBAction func signUp(_ sender: Any) {
        if (!checkIfEmpty()) {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (user, error) in
                if user != nil {
                    print("User Created")
                } else {
                    if let myError = error?.localizedDescription {
                        print(myError)
                    } else {
                        print("ERROR")
                    }
                }
            }
            let user = User(name: nameText.text!, username: usernameText.text!, email: emailText.text!, password: passwordText.text!, isPrivate: false)
            ParentStruct().addUser(user: user)
            UserDefaults.standard.set(user.username, forKey: defaultsKeys.usernameKey)
            UserDefaults(suiteName: "group.InstagramClone.messages")?.set(user.username, forKey: defaultsKeys.usernameKey)
            exitView()
        }
    }
    func buildGestures(){
        //cancel label
        cancelLabel.isUserInteractionEnabled = true
        cancelLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(exitView)))
    }
    
    func underline() {
        let spacing = 0.5
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = cancelLabel.textColor
        cancelLabel.addSubview(line)
        cancelLabel.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[line]|", metrics: nil, views: ["line":line]))
        cancelLabel.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(1)]-(\(-spacing))-|", metrics: nil, views: ["line":line]))
    }
    
    @objc func exitView(_ tapGesture : UITapGestureRecognizer? = nil){
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
            self.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }
    
    func warnUser(textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.red.cgColor
        textField.shake()
    }
    
    func checkIfEmpty() -> Bool {
        if (nameText.text == "") {
            print("Add Name")
            warnUser(textField: nameText)
        } else if (usernameText.text == "") {
            print("Add Username")
            warnUser(textField: usernameText)
        } else if ((emailText.text == "") || !isValidEmail(emailStr: emailText.text!)) {
            print("Add Email")
            warnUser(textField: emailText)
        } else if (usernameText.text == "") {
            print("Add Username")
            warnUser(textField: usernameText)
        } else if (passwordText.text == "") {
            print("Add Password")
            warnUser(textField: passwordText)
        } else {
            return false
        }
        return true
    }
    
     func isValidEmail(emailStr:String) -> Bool {

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }

}
