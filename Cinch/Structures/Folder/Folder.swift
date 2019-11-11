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
    var defaultFolders = ["https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/DefaultFolderImages%2FDrAqgYTAmTfKhfkkwKeC?alt=media&token=1c21d9eb-cc37-4836-8b4a-773f98d9690b", "https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/DefaultFolderImages%2FDwjqamziWtBSChcmueeK?alt=media&token=762dc17f-ade1-473e-9eaa-b34a2fd4fd2e", "https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/DefaultFolderImages%2FEFgTUdbEswhiGAKWuuzS?alt=media&token=efd16a9b-3bbc-40c0-8861-c35162b4ff07", "https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/DefaultFolderImages%2FJsNcGcRFhgSblaVgCxwJ?alt=media&token=e6d4514f-5e4e-4144-a01b-359fb66fe966", "https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/DefaultFolderImages%2FSBzNIqFxNryCojsWxeza?alt=media&token=e0e32054-33eb-472e-a8ca-a734aef15fd9", "https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/DefaultFolderImages%2FTalSfzHfTjaiUlUTDkwu?alt=media&token=b72b3042-69d6-4c53-8b1c-508d2b7e315b", "https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/DefaultFolderImages%2FYeTqgeCNywwYeUhymSKj?alt=media&token=141febf0-decb-4a32-90c3-e14f06ec32ee", "https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/DefaultFolderImages%2FidazchgGjffrllvHifuT?alt=media&token=16f45591-f779-4b14-b379-1672a2e050ae", "https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/DefaultFolderImages%2FsnqGvVKKiieyeJdXmuTf?alt=media&token=d379dcfa-26db-4dd1-ae60-36ec2475dfbe", "https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/DefaultFolderImages%2FsofnvvqoKthetiatujxz?alt=media&token=17fd70f7-2ce1-44f8-8e81-4b309da9e763"
    ]
    
    //new
    var followers : [String] = [] //a list of people following this folder
    var followersCount = 0
    var iconLink : String?
    
    //default variables
    let defaultContentImage = UIImage(named: "addImage")
    
    
    init(folderName : String) {
        self.folderName = folderName
        self.icon = UIImage(named: "placeholder.png")
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
        
        let folderString:[String : Any] = ["folderName": folderName, "icon": iconLink ?? defaultFolders[Int.random(in: 0 ..< 10)], "dateCreated": dateCreated!, "dateLastModified": dateLastModified!, "isPrivate": isPrivate, "numOfImages": numOfImages, "numOfVideos": numOfVideos, "content": content, "followers" : followersDict, "followersCount" : followersCount]
        
        return folderString
    }
    
}
