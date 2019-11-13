//
//  LoginViewController.swift
//  Cinch
//
//  Created by Ahmed Gedi on 11/10/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

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
    }
    
    @IBAction func signUp(_ sender: Any) {
        if (createUser()) {
            UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
                self.dismiss(animated: true, completion: nil)
            }, completion: nil)
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
    
    func createUser() -> Bool {
        if (nameText.text == "") {
            print("Add Name")
            warnUser(textField: nameText)
        } else if (usernameText.text == "") {
            print("Add Username")
            warnUser(textField: usernameText)
        } else if (emailText.text == "") {
            print("Add Email")
            warnUser(textField: emailText)
        } else if (passwordText.text == "") {
            print("Add Password")
            warnUser(textField: passwordText)
        } else {
            let user = User(name: nameText.text!, username: usernameText.text!, email: emailText.text!, password: passwordText.text!, isPrivate: false)
            ParentStruct().addUser(user: user)
            print("User Created")
            return true
        }
        return false
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
