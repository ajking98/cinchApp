//
//  EditProfileViewController.swift
//  Cinch
//
//  Created by Ahmed Gedi on 11/11/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var bioText: UITextField!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        addGestures()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changePhoto(_ sender: Any) {
        print("Hello")
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func submitChange(_ sender: Any) {
        let username = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)
        if (imageView.image != nil) {
            StorageStruct().uploadImage(image: imageView.image!) { (newImage) in
                UserStruct().readProfilePic(user: username!, completion: { (oldImage) in
                    if (oldImage != newImage) {
                        UserStruct().updateProfilePic(user: username!, newProfilePic: newImage)
                    }
                })
                if self.nameText.text != "" {
                    UserStruct().updateName(user: username!, newName: self.nameText.text!)
                }
                if self.bioText.text != "" {
                    UserStruct().updateBiography(user: username!, newBiography: self.bioText.text!)
                }
            }
        }
        
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
            self.dismiss(animated: true, completion: nil)
        }, completion: nil)
        
        self.viewWillAppear(true)
    }
    
    // After closing you need to refresh the profile view to show the new profile image and other info
    @IBAction func closeAction(_ sender: Any) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
            self.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }
    
    func addGestures() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closeAction(_:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(swipeDown)
    }

}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}
