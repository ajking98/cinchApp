//
//  Post.swift
//  InstagramClone
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
    
    //image
    var image : UIImage?
    
    //video
    var video : AVPlayer?
    
    
    ///called when a post is first being made
    init(isImage : Bool, postOwner : String, link : String) {
        
        self.isImage = isImage
        self.link = link
        self.numberOfLikes = 0
        self.likedBy = []
        self.postOwner = postOwner
        self.dateCreated = Date().timeIntervalSince1970
        self.tags = []
    }
    
    
    ///Initialized when All data is given
    init(isImage : Bool, numberOfLikes : Int, postOwner : String, likedBy : [String], dateCreated : Double, tags : [String], link : String) {
        
        self.isImage = isImage
        self.link = link
        self.numberOfLikes = numberOfLikes
        self.postOwner = postOwner
        self.likedBy = likedBy
        self.dateCreated = dateCreated
        self.tags = tags
    }
    
    
    func toString() -> [String : Any] {
        var tagsDict : [String : String] = [:]
        var likedByDict : [String : String] = [:]
        
        for tag in tags! {
            tagsDict[tag] = tag
        }
        
        for likedByUser in likedBy! {
            likedByDict[likedByUser] = likedByUser
        }
        
        
        let postDict : [String : Any] = ["isImage" : isImage as Any, "numberOfLikes" : numberOfLikes as Any, "likedBy" : likedByDict as Any, "postOwner" : postOwner as Any, "dateCreated" : dateCreated as Any, "tags" : tagsDict as Any, "link" : link as Any]
        
        return postDict
    }
    
}
