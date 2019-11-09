//
//  FolderClass2.swift
//  Cinch
//

import Foundation
import UIKit


class Folder {
    
    var folderName : String = ""
    var icon : UIImage?
    var dateCreated : TimeInterval?
    var dateLastModified : TimeInterval?
    var content : [String : String] = [:]
    var numOfImages : Int = 0
    var numOfVideos : Int = 0
    var isPrivate : Bool = false
    
    //new
    var followers : [String] = [] //a list of people following this folder
    var followersCount = 0
    var iconLink : String?
    
    //default variables
    let defaultContentImage = UIImage(named: "addImage")
    
    
    init(folderName : String) {
        self.folderName = folderName
        self.icon = UIImage(named: "1")
        self.dateCreated = Date().timeIntervalSince1970
        self.dateLastModified = Date().timeIntervalSince1970
        self.content = [:]
        self.numOfImages = 0
        self.numOfVideos = 0
        self.isPrivate = false
    }
    
    init(folderName : String, icon : UIImage) {
        self.folderName = folderName
        self.icon = icon
        self.dateCreated = Date().timeIntervalSince1970
        self.dateLastModified = Date().timeIntervalSince1970
        self.content = [:]
        self.numOfImages = 0
        self.numOfVideos = 0
        self.isPrivate = false
    }
    
    init(folderName : String, iconLink : String) {
        self.folderName = folderName
        self.iconLink = iconLink
        self.dateCreated = Date().timeIntervalSince1970
        self.dateLastModified = Date().timeIntervalSince1970
        self.content = [:]
        self.numOfImages = 0
        self.numOfVideos = 0
        self.isPrivate = false
    }
    
    
    init(folderName : String, icon : UIImage, dateCreated : Date, dateLastModified : Date, content : [String : String], numOfImages : Int, numOfVideos : Int, isPrivate : Bool) {
        self.folderName = folderName
        self.icon = icon
        self.dateCreated = dateCreated.timeIntervalSince1970
        self.dateLastModified = dateLastModified.timeIntervalSince1970
        self.content = content
        self.numOfImages = numOfImages
        self.numOfVideos = numOfVideos
        self.isPrivate = isPrivate
    }
    
    
    ///Used when all data is available
    init(folderName : String, iconLink : String, dateCreated : Double, dateLastModified : Double, content : [String : String], numOfImages : Int, numOfVideos : Int, isPrivate : Bool, followers : [String], followersCount : Int) {
        self.folderName = folderName
        self.iconLink = iconLink
        self.dateCreated = dateCreated
        self.dateLastModified = dateLastModified
        self.content = content
        self.numOfImages = numOfImages
        self.numOfVideos = numOfVideos
        self.isPrivate = isPrivate
        self.followers = followers
        self.followersCount = followersCount
    }
    
    
    
    func toString() -> [String: Any] {
        var followersDict : [String : String] = [:]
        for follower in followers {
            followersDict[follower] = follower
        }
        
        let folderString:[String : Any] = ["folderName": folderName, "icon": iconLink ?? "https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/userImages%2FGcdcSCTmFaruYKWnntBr?alt=media&token=35e80ea4-83fa-4941-8f3a-8b18ed86a35d", "dateCreated": dateCreated!, "dateLastModified": dateLastModified!, "isPrivate": isPrivate, "numOfImages": numOfImages, "numOfVideos": numOfVideos, "content": content, "followers" : followersDict, "followersCount" : followersCount]
        
        return folderString
    }
    
}
