//
//  ProfilePageFunctions.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 1/30/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit


extension ProfileViewController {
    
    @objc func settingToggle() {
        print("Toggled Settings")
        let alert = UIAlertController(title: "Function not Available", message: "Sorry, we are currently working on this feature.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    
    @objc func handleEditProfile(){
        print("Editing")
        print(profileName)
        let next:EditProfileViewController = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        next.profileName = profileName
        next.profileImage = profileImageView
        self.present(next, animated: true, completion: nil)
    }
    
    @objc func handleFollow(){
        if isFollowing {
            print("UnFollowing")
        }
        else{
            print("Following")
        }
    }
    
    @objc func handleSegmentTap() {
        print("this is the segment: ", segmentControl.selectedSegmentIndex)
    }
    
    
}

extension EditProfileViewController {
    @objc func handleChangePhoto(){
        print("Changing")
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func saveButtonAction() {
        print("Saving")
        let username = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)
        if (didChangeProfileImage) {
            guard let image = imageView.image else { return }
            guard let profileImage = profileImage else { return }
            StorageStruct().uploadImage(image: image) { (newImage) in
                UserStruct().updateProfilePic(user: username!, newProfilePic: newImage)
                print(username)
                profileImage.image = image
            }
        }

        if self.nameText.text != "" {
            UserStruct().updateName(user: username!, newName: self.nameText.text!)
            print(username)
            self.profileName = self.nameText.text!
        }
        self.dismiss(animated: true, completion: nil)
    }
}
