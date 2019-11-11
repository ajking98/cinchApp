//
//  FolderReference.swift
//  Cinch
//
//  Created by Ahmed Gedi on 8/29/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit

/*
 This is a folder reference
 when summoning the folders in the frontend, the code should pass the admin string through the user's DB, find the admin with the folder, then pass the folder name through the user's folders to find the specific folder and its content
 */
class FolderReference {
    var admin : String = "" //the owner of the folder you are referencing
    var folderName : String = ""
    
    
    init(admin : String, folderName : String) {
        self.admin = admin
        self.folderName = folderName
    }
    
    func toString() -> [String : String] {
        let dict : [String : String] = ["admin" : admin, "folderName" : folderName]
        return dict
    }
}
