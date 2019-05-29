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
    
    func printTagInfo() {
        print("The Tagged Images for \(tagName) are: \n")
        for i in 0..<tagImages.count {
            print("\(tagImages[i]) \n")
        }
    }
    
    init(tagName:String, tagImages:[String]) {
        self.tagName = tagName
        self.tagImages = tagImages
    }
    
    
    
    
}
