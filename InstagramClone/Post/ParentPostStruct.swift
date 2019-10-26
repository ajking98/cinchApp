//
//  ParentPostStruct.swift
/*
 Functions For: CRD commands
    1. addPost (create)
    2. readPost
    3. deletePost
 */
//
//  Created by Ahmed Gedi on 8/31/19.
//

import Foundation
import FirebaseDatabase


struct ParentPostStruct {
    
    let DB = Database.database().reference().child("posts")
    
    ///Adds post to DB
    func addPost(post : Post) {
        DB.child(post.link!).setValue(post.toString())
    }
    
    ///deletes a post from DB with the given Link
    func deletePost(postLink : String) {
        DB.child(postLink).removeValue()
    }
    
    
    ///Reads complete post from database
    func readPost(postLink : String, completion : @escaping(Post)-> Void) {
        DB.child(postLink).observeSingleEvent(of: .value) { (snapshot) in
            if let post = snapshot.value as? [String : Any] {
                
                let likedBy = post["likedBy"] != nil ? post["likedBy"] as! [String : String] : [:] as! [String : String]
                
                let tags = post["tags"] != nil ? post["tags"] as! [String : String] : [:] as! [String : String]
                
            
                
                let thisPost = Post(isImage: post["isImage"] as! Bool, numberOfLikes: post["numberOfLikes"] as! Int, postOwner: post["postOwner"] as! String, likedBy: Array(likedBy.keys), dateCreated: post["dateCreated"] as! Double, tags: Array(tags.keys), link: post["link"] as! String)
                
                
                completion(thisPost)
            }
        }
    }
    
}