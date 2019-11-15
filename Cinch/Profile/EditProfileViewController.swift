//
//  EditProfileViewController.swift
//  Cinch
//
//  Created by Ahmed Gedi on 11/11/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    var profileImage: UIImageView?
    var profileName: UILabel?
    var didChangeProfileImage = false
//    @IBOutlet weak var bioText: UITextField!
    
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        addGestures()
        // Do any additional setup after loading the view.
        setUp()
    }
    
    func setUp() {
        if let profileImage = profileImage {
            imageView.image = profileImage.image
        }
        if let profileName = profileName {
            nameText.placeholder = profileName.text
        }
        underline()
    }
    
    @IBAction func changePhoto(_ sender: Any) {
        print("Hello")
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func submitChange(_ sender: Any) {
        let username = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)
        if (didChangeProfileImage) {
            guard let image = imageView.image else { return }
            guard let profileImage = profileImage else { return }
            StorageStruct().uploadImage(image: image) { (newImage) in
                UserStruct().updateProfilePic(user: username!, newProfilePic: newImage)
                profileImage.image = image
            }
        }
            
        if self.nameText.text != "" {
            UserStruct().updateName(user: username!, newName: self.nameText.text!)
            self.profileName?.text = self.nameText.text!
        }
//        if self.bioText.text != "" {
//            UserStruct().updateBiography(user: username!, newBiography: self.bioText.text!)
//        }
        
        closeAction()
        
        self.viewWillAppear(true)
    }
    
    //exits the viewcontroller without saving the data
    @IBAction func closeAction(_ sender: Any? = nil) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
            self.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }
    
    func addGestures() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closeAction(_:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(swipeDown)
        
        
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
    
    //escapes the current screen
    @objc func exitView(_ tapGesture : UITapGestureRecognizer? = nil){
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
            self.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }

}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = image
            didChangeProfileImage = true
        }
        
        dismiss(animated: true, completion: nil)
    }
}
