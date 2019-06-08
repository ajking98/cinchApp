//
//  FolderClass2.swift
//  InstagramClone
//

import Foundation
import UIKit


class Folder {
    
    var folderName : String?
    var icon : UIImage?
    var dateCreated : Date?
    var dateLastModified : Date?
    var content : [Any]?
    var numOfImages : Int?
    var numOfVideos : Int?
    var isPrivate : Bool?
    
    //default variables
    let defaultIcon = UIImage(named: "nature")
    
    
    init(folderName : String) {
        self.folderName = folderName
        self.icon = defaultIcon
        self.dateCreated = Date()
        self.dateLastModified = Date()
        self.content = []
        self.numOfImages = 0
        self.numOfVideos = 0
        self.isPrivate = false
    }
    
    init(folderName : String, icon : UIImage) {
        self.folderName = folderName
        self.icon = icon
        self.dateCreated = Date()
        self.dateLastModified = Date()
        self.content = []
        self.numOfImages = 0
        self.numOfVideos = 0
        self.isPrivate = false
    }
    
    
    init(folderName : String, icon : UIImage, dateCreated : Date, dateLastModified : Date, content : [Any], numOfImages : Int, numOfVideos : Int, isPrivate : Bool) {
        self.folderName = folderName
        self.icon = icon
        self.dateCreated = dateCreated
        self.dateLastModified = dateLastModified
        self.content = content
        self.numOfImages = numOfImages
        self.numOfVideos = numOfVideos
        self.isPrivate = isPrivate
    }
    
    
}

