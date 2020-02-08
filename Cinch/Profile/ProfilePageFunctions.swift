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
    }
    
    
    @objc func handleEditProfile(){
        print("Editing")
        let next:EditProfileViewController = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
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
//        let username = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)
//        if (didChangeProfileImage) {
//            guard let image = imageView.image else { return }
//            guard let profileImage = profileImage else { return }
//            StorageStruct().uploadImage(image: image) { (newImage) in
//                UserStruct().updateProfilePic(user: username!, newProfilePic: newImage)
//                profileImage.image = image
//            }
//        }
//
//        if self.nameText.text != "" {
//            UserStruct().updateName(user: username!, newName: self.nameText.text!)
//            self.profileName?.text = self.nameText.text!
//        }
        self.dismiss(animated: true, completion: nil)
    }
}
