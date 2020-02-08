//
//  EditProfileViewController.swift
//  Cinch
//
//  Created by Ahmed Gedi on 2/7/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    // Measurement Variables
    var bounds = UIScreen.main.bounds
    var width:CGFloat = 0.0
    var height:CGFloat = 0.0
    
    // Views
    var titleBar = UIView()
    var imageView = UIImageView()
    var nameText = UITextField()
    var changePhoto = UILabel()
    var saveButton = UIButton()
    
    // ImagePicker
    var imagePicker = UIImagePickerController()
    var didChangeProfileImage = false
    
    // Data Points
    var profileImage: UIImageView?
    var profileLabel: UILabel?
    var profileName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generalSetup()
        self.setupTitleBar()
        self.setupEditLabel()
        self.setUpProfileImage()
        self.setupChangePhoto()
        self.setupNameField()
        self.setupSaveButton()
    }
    
    func generalSetup() {
        imagePicker.delegate = self
        width = bounds.size.width
        height = bounds.size.height
    }
    
    func setupTitleBar() {
        view.addSubview(titleBar)
        
        titleBar.frame = CGRect.zero
        titleBar.translatesAutoresizingMaskIntoConstraints = false
        titleBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        titleBar.heightAnchor.constraint(equalToConstant: height*0.1).isActive = true
        titleBar.widthAnchor.constraint(equalToConstant: width).isActive = true
        titleBar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        createHorizontalBar(superView: view, relativeView: titleBar, relativeViewConstant: 0, widthConstant: Float(width))
    }
    
    func setupEditLabel() {
        var editLabel = UILabel()
        editLabel.text = "Edit Profile"
        editLabel.textAlignment = .center
        editLabel.font = .boldSystemFont(ofSize: height*0.02)
        titleBar.addSubview(editLabel)
        
        editLabel.frame = CGRect.zero
        editLabel.translatesAutoresizingMaskIntoConstraints = false
        editLabel.centerXAnchor.constraint(equalTo: titleBar.centerXAnchor).isActive = true
        editLabel.heightAnchor.constraint(equalToConstant: height*0.05).isActive = true
        editLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        editLabel.bottomAnchor.constraint(equalTo: titleBar.bottomAnchor).isActive = true
    }
    
    func setUpProfileImage() {
        if profileImage?.image != nil {
            imageView.image = profileImage?.image
        } else {
            imageView.image = UIImage(named: "grayCircle")
        }
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        view.addSubview(imageView)
        
        imageView.frame = CGRect.zero
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: height*0.12).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: height*0.12).isActive = true
        imageView.topAnchor.constraint(equalTo: titleBar.bottomAnchor, constant: height*0.02).isActive = true
        imageView.layer.cornerRadius = height * 0.06
    }
    
    func setupChangePhoto() {
        changePhoto.text = "Change Photo"
        changePhoto.textAlignment = .center
        changePhoto.font = .boldSystemFont(ofSize: height*0.015)
        view.addSubview(changePhoto)
        
        changePhoto.frame = CGRect.zero
        changePhoto.translatesAutoresizingMaskIntoConstraints = false
        changePhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changePhoto.heightAnchor.constraint(equalToConstant: height*0.05).isActive = true
        changePhoto.widthAnchor.constraint(equalToConstant: width*0.4).isActive = true
        changePhoto.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        changePhoto.isUserInteractionEnabled = true
        changePhoto.addGestureRecognizer(tap)
        
    }
    
    func setupNameField() {
        if profileName != "" {
            print("here")
            print(profileName)
            nameText.text = profileName
        } else {
            print("there")
            nameText.placeholder = "Name"
        }
        nameText.font = UIFont.systemFont(ofSize: 15)
        nameText.borderStyle = UITextField.BorderStyle.none
        nameText.autocorrectionType = UITextAutocorrectionType.no
        nameText.keyboardType = UIKeyboardType.default
        nameText.returnKeyType = UIReturnKeyType.done
        nameText.clearButtonMode = UITextField.ViewMode.whileEditing
        nameText.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        nameText.delegate = self
        view.addSubview(nameText)
        
        nameText.frame = CGRect.zero
        nameText.translatesAutoresizingMaskIntoConstraints = false
        nameText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameText.heightAnchor.constraint(equalToConstant: height*0.05).isActive = true
        nameText.widthAnchor.constraint(equalToConstant: width*0.8).isActive = true
        nameText.topAnchor.constraint(equalTo: changePhoto.bottomAnchor, constant: height*0.01).isActive = true
        
        createHorizontalBar(superView: view, relativeView: nameText, relativeViewConstant: 0, widthConstant: Float(width*0.8))
    }
    
    func setupSaveButton() {
        saveButton.backgroundColor = UIColor.customRed
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)

        view.addSubview(saveButton)
        
        saveButton.frame = CGRect.zero
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: height*0.05).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: width*0.4).isActive = true
        saveButton.topAnchor.constraint(equalTo: nameText.bottomAnchor, constant: height*0.05).isActive = true
    }
    
    func createHorizontalBar(superView: UIView, relativeView: UIView, relativeViewConstant: Float, widthConstant: Float) {
        var horizontalBar = UIView()
        horizontalBar.backgroundColor = UIColor.lightishGray
        superView.addSubview(horizontalBar)

        horizontalBar.frame = CGRect.zero
        horizontalBar.translatesAutoresizingMaskIntoConstraints = false
        horizontalBar.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
        horizontalBar.heightAnchor.constraint(equalToConstant: 1).isActive = true
        horizontalBar.widthAnchor.constraint(equalToConstant: CGFloat(widthConstant)).isActive = true
        horizontalBar.topAnchor.constraint(equalTo: relativeView.bottomAnchor, constant: CGFloat(relativeViewConstant)).isActive = true
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

extension EditProfileViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        //print("TextField should begin editing method called")
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        //print("TextField did begin editing method called")
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        //print("TextField should snd editing method called")
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        //print("TextField did end editing method called")
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        //print("TextField did end editing with reason method called")
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        //print("While entering the characters this method gets called")
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // called when clear button pressed. return NO to ignore (no notifications)
        //print("TextField should clear method called")
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        //print("TextField should return method called")
        view.endEditing(true)
        // may be useful: textField.resignFirstResponder()
        return true
    }

}
