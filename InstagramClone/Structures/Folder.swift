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
    
    //new
    var admin : [String]? //the root owner of the folder that could edit it 
    var followers : [String]? //a list of people following this folder
    
    //default variables
    let defaultIcon = UIImage(named: "nature")
    let defaultContentImage = UIImage(named: "addImage")
    
    
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
    
    func toString() -> [String: Any] {
        let folderString:[String : Any] = ["icon": "https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/userImages%2FGcdcSCTmFaruYKWnntBr?alt=media&token=35e80ea4-83fa-4941-8f3a-8b18ed86a35d", "dateCreated": dateCreated?.toString(), "dateLastModified": dateLastModified?.toString(), "isPrivate": isPrivate, "numOfImages": numOfImages, "numOfVideos": numOfVideos, "content": content]
        StorageStruct().UploadContent(user: UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!, folderName: folderName!, content: defaultContentImage!)
        return folderString
    }
    
}
