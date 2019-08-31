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
    var numberOfLikes : Int?
    var likedBy : [String]?
    var postOwner : String?
    var dateCreated : NSDate?
    var tags : [String]?
    
    //image
    var image : UIImage?
    var imageLink : String?
    
    //video
    var video : AVPlayer?
    var videoLink : String?
    
    
    //TODO call to the database and update the values (should call be created by the struct)
    init(image : UIImage, numberOfLikes : Int, postOwner : String, likedBy : [String], dateCreated : NSDate, tags : [String]) {
        isImage = true
        self.image = image
        self.numberOfLikes = numberOfLikes
        self.postOwner = postOwner
        self.likedBy = likedBy
        self.dateCreated = dateCreated
        self.tags = tags
    }
    
    
    ///Initialized when all the data is given
//    init(isImage : Bool, numberOfLikes : Int, postOwner : String, likedBy : [String], dateCreated : Double, tags : [String], link : String) {
//        isImage = true
//        self.image = image
//        self.numberOfLikes = numberOfLikes
//        self.postOwner = postOwner
//        self.likedBy = likedBy
//        self.dateCreated = dateCreated
//        self.tags = tags
//    }
    
    
    //TODO call to the database and update the values (should created by the struct)
    init(video : AVPlayer, numberOfLikes : Int, postOwner : String, likedBy : [String], dateCreated : NSDate, tags : [String]) {
        isImage = false
        self.video = video
        self.numberOfLikes = numberOfLikes
        self.postOwner = postOwner
        self.likedBy = likedBy
        self.dateCreated = dateCreated
        self.tags = tags
    }

    
}
