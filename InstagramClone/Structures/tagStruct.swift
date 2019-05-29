//
//  tagStruct.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 5/29/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation

struct tagStruct {
    var tagName:String
    var tagImages:[String]
    
    func getName() -> String {
        return tagName
    }
    
    mutating func setName(newName:String) {
        tagName = newName
    }
    
    func getTagImages() -> [String] {
        return tagImages
    }
    
    mutating func setTagImages(newTagImages:[String]) {
        tagImages = newTagImages
    }
    
    init(tagName:String, tagImages:[String]) {
        self.tagName = tagName
        self.tagImages = tagImages
    }
    
    
    
    
}
