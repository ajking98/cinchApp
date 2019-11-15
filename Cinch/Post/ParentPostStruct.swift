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
        guard let link = post.link else { return }
        let updatedLink = convertStringToKey(link: link)
        DB.child(updatedLink).setValue(post.toString())
        
        //TODO THIS SHOULD BE DONE WITHIN A GOOGLE CLOUD FUNCTION INSTEAD TO OFFLOAD TO THE CLOUD INSTEAD OF LETTING THE USER DO IT ON THEIR DEVICE
        guard let username = post.postOwner else { return }
        UserStruct().readFollowers(user: username) { (followers) in
            for (_, follower) in followers {
                print("adding newContent to user: ", follower)
                UserStruct().addNewContent(user: follower, link: link)
            }
        }
    }
    
    ///deletes a post from DB with the given Link
    func deletePost(postLink : String) {
        let updatedLink = convertStringToKey(link: postLink)
        DB.child(updatedLink).removeValue()
    }
    
    
    ///Reads complete post from database
    func readPost(postLink : String, completion : @escaping(Post)-> Void) {
        let updatedLink = convertStringToKey(link: postLink)
        
        DB.child(updatedLink).observeSingleEvent(of: .value) { (snapshot) in
            if let post = snapshot.value as? [String : Any] {
                
                let likedBy = post["likedBy"] != nil ? post["likedBy"] as! [String : String] : [:] as! [String : String]
                
                let tags = post["tags"] != nil ? post["tags"] as! [String : String] : [:] as! [String : String]
                
            
                
                let thisPost = Post(isImage: post["isImage"] as! Bool, numberOfLikes: post["numberOfLikes"] as! Int, postOwner: post["postOwner"] as! String, likedBy: Array(likedBy.keys), dateCreated: post["dateCreated"] as! Double, tags: Array(tags.keys), link: post["link"] as! String)
                
                
                completion(thisPost)
            }
        }
    }
    
}
