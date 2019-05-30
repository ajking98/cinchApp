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

    func getName() -> String {
        return folderName
    }
    
    mutating func setName(newName:String) {
        folderName = newName
    }
    
    func getIconImage() -> String {
        return iconImage
    }
    
    mutating func setIconImage(newIconImage:String) {
        iconImage = newIconImage
    }
    
    func getNumOfImages() -> Int {
        return numOfImages
    }
    
    mutating func setNumOfImages(newNumOfImages:Int) {
        numOfImages = newNumOfImages
    }
    
    func getNumOfVideos() -> Int {
        return numOfVideos
    }
    
    mutating func setNumOfVideos(newNumOfVideos:Int) {
        numOfVideos = newNumOfVideos
    }
    
    func getPrivateOrPublic() -> Bool {
        return privateOrPublic
    }
    
    mutating func setPrivateOrPublic(newPrivateOrPublic:Bool) {
        privateOrPublic = newPrivateOrPublic
    }
    
    func getDateCreated() -> String {
        return dateCreated
    }
    
    mutating func setDateCreated(newDateCreated:String) {
        dateCreated = newDateCreated
    }
    
    func getDateModified() -> String {
        return dateModified
    }
    
    mutating func setDateModified(newDateModified:String) {
        dateModified = newDateModified
    }
    
    func getImages() -> [String] {
        return imgs
    }
    
    mutating func setImages(newImages:[String]) {
        imgs = newImages
    }
    
    func printFolderInfo() {
        print("This Folder Info is as follows: \n Folder Name: \(folderName) \n Icon Image Location: \(iconImage) \n Number of Images: \(numOfImages) \n Number of Videos: \(numOfVideos) \n Folder Privacy: \(privateOrPublic) \n Date Created: \(dateCreated) \n Date Modified: \(dateModified) \n")
    }
    
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
