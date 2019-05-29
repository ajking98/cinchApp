//
//  folderStruct.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 5/28/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation

struct folderStruct {
    var folderName:String
    var iconImage:String
    var numOfImages:Int
    var numOfVideos:Int
    var privateOrPublic:Bool
    var dateCreated:String
    var dateModified:String
    var imgs:[String]

    init(folderName:String, iconImage:String, numOfImages:Int, numOfVideos:Int, privateOrPublic:Bool, dateCreated:String, dateModified:String, imgs:[String]) {
        self.folderName = folderName
        self.iconImage = iconImage
        self.numOfImages = numOfImages
        self.numOfVideos = numOfVideos
        self.privateOrPublic = privateOrPublic
        self.dateCreated = dateCreated
        self.dateModified = dateModified
        self.imgs = imgs
    }
}
