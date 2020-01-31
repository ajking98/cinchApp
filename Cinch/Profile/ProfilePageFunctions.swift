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
        print("working")
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
        print("we are switching")
    }
    
    
}
