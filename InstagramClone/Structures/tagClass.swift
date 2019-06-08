//
//  tagClass.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 6/2/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation

import UIKit
import FirebaseDatabase
import FirebaseStorage

class tagClass {
    var tag = tagStruct()
    var tagName:String?
    var tagImages:[String] = [String]()
    
    init(tagName:String, tagImages:[String]) {
        self.tagName = tagName
        self.tagImages = tagImages
    }
    
    init(tagName:String) {
        self.tagName = tagName
        self.tagImages = tag.tagImages
    }
    
}
