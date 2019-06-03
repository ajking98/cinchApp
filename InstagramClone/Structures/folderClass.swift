//
//  folderClass.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 6/2/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation

import UIKit
import FirebaseDatabase
import FirebaseStorage

class folderClass {
    var folder = folderStruct()
    var folderName:String
    var isPrivate:Bool
    var icon:String
    var numOfImages:Int
    var numOfVideos:Int
    var dateCreated:String
    var dateModified:String
    var images:[String]
    
    init(folderName:String, isPrivate:Bool, icon:String, numOfImages:Int, numOfVideos:Int, dateCreated:String, dateModified:String, images:[String]) {
        self.folderName = folderName
        self.isPrivate = isPrivate
        self.icon = icon
        self.numOfImages = numOfImages
        self.numOfVideos = numOfVideos
        self.dateCreated = dateCreated
        self.dateModified = dateModified
        self.images = images
    }
    
    init(folderName:String) {
        self.folderName = folderName
        self.isPrivate = folder.isPrivate
        self.icon = folder.icon
        self.numOfImages = folder.numOfImages
        self.numOfVideos = folder.numOfVideos
        self.dateCreated = folder.createDate()
        self.dateModified = folder.updateDate()
        self.images = folder.images
    }
    
}
