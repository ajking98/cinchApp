//
//  LoginViewController.swift
//  Cinch
//
//  Created by Ahmed Gedi on 11/10/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

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
    
    @IBAction func login(_ sender: Any) {
        if (!checkIfEmpty()) {
            ParentStruct().readUser(user: usernameText.text!) { (user) in
                print("User Existed")
                if user != nil {
                    Auth.auth().signIn(withEmail: self.emailText.text!, password: self.passwordText.text!) { (user, error) in
                        if user != nil {
                            print("Signed In")
                        } else {
                            if let myError = error?.localizedDescription {
                                print(myError)
                            } else {
                                print("ERROR")
                            }
                        }
                    }
                    UserDefaults.standard.set(self.usernameText.text!, forKey: defaultsKeys.usernameKey)
                    if UserDefaults.standard.string(forKey: defaultsKeys.stateOfUser) == "Signup/Login" {
                        UserDefaults.standard.set("Logout", forKey: defaultsKeys.stateOfUser)
                    }
                    UserDefaults(suiteName: "group.InstagramClone.messages")?.set(self.usernameText.text!, forKey: defaultsKeys.usernameKey)
                }
            }
            exitView()
            SignUpViewController().dismiss(animated: true, completion: nil)
            ProfilePageViewController().viewDidAppear(true)

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
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            self.viewWillAppear(true)
        }, completion: nil)
    }
    
    func warnUser(textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.red.cgColor
        textField.shake()
    }
    
    func checkIfEmpty() -> Bool {
        if (usernameText.text == "") {
            print("Add Username")
            warnUser(textField: usernameText)
        } else if (emailText.text == "") {
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
    
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.4
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
