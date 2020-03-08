//
//  Post.swift
//  Cinch
//
//  Created by Ahmed Gedi on 8/8/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class Post {
    
    var isImage : Bool?
    var link : String?
    var numberOfLikes : Int?
    var likedBy : [String]?
    var postOwner : String?
    var dateCreated : TimeInterval?
    var tags : [String]?
    var thumbnail: [String]? //1 sec long images
    var contentKey = ""

    
    ///called when a post is first being made
    init(isImage : Bool, postOwner : String, link : String, contentKey: String = "", _ thumbnail: [String]? = nil) {
        
        self.isImage = isImage
        self.link = link
        self.numberOfLikes = 0
        self.likedBy = []
        self.postOwner = postOwner
        self.dateCreated = Date().timeIntervalSince1970
        self.tags = []
        self.thumbnail = thumbnail
        if contentKey == "" {
            self.contentKey = StorageStruct().randomString(5)
        }
    }
    
    
    ///Initialized when All data is given
    init(isImage : Bool, numberOfLikes : Int, postOwner : String, likedBy : [String], dateCreated : Double, tags : [String], link : String, contentKey: String = "", _ thumbnail: [String]? = nil) {
        
        self.isImage = isImage
        self.link = link
        self.numberOfLikes = numberOfLikes
        self.postOwner = postOwner
        self.likedBy = likedBy
        self.dateCreated = dateCreated
        self.tags = tags
        self.thumbnail = thumbnail
        self.contentKey = contentKey
    }
    
    
    func toString() -> [String : Any] {
        var tagsDict : [String : String] = [:]
        var likedByDict : [String : String] = [:]
        var thumbnailDict : [String : String] = [:]
        
        for tag in tags! {
            tagsDict[tag] = tag
        }
        
        for likedByUser in likedBy! {
            likedByDict[likedByUser] = likedByUser
        }
        
        if let sortedThumbnail = thumbnail?.sorted() {
            for index in 0 ..< sortedThumbnail.count {
                thumbnailDict[String(index)] = sortedThumbnail[index]
            }
        }
        
        if contentKey == "" {
            contentKey = StorageStruct().randomString(5)
        }
        
        print("this is the contentKey: ", contentKey)
        let postDict : [String : Any] = ["isImage" : isImage as Any, "numberOfLikes" : numberOfLikes as Any, "likedBy" : likedByDict as Any, "postOwner" : postOwner as Any, "dateCreated" : dateCreated as Any, "tags" : tagsDict as Any, "link" : link as Any, "thumbnail" : thumbnailDict as Any, "contentKey" : contentKey ]
        
        return postDict
    }
    
}
