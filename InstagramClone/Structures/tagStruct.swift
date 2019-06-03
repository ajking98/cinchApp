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
    
    init() {
        tagName = ""
        tagImages = [String]()
    }
//    func createTag(tagName:String) -> tagStruct {
//        // Creates Tag with tagName parameter and empty string array
//        var tagObject = tagStruct(tagName: tagName, tagImages: tagImages)
//        return tagObject
//    }
//
//    func addImageToTag(image:String) {
//        tagImages.append(image)
//    }
//
//    func deleteImageFromTag(image:String) -> String {
//        var index = 0
//        if let i = tagImages.firstIndex(of: image) {
//            tagImages.remove(at: i)
//            index = i
//        }
//        return tagImages[index]
//    }
//
//    func readTagContent() -> [String] {
//        return tagImages
//    }
//
//    func printTagInfo() {
//        print("The Tagged Images for \(tagName) are: \n")
//        for i in 0..<tagImages.count {
//            print("\(tagImages[i]) \n")
//        }
//    }
    
}
