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
        let postString = post.toString()
        print("well well well: ", postString["contentKey"])
        guard let key = postString["contentKey"] as? String else { return }
        DB.child(key).setValue(postString)
        
        //TODO THIS SHOULD BE DONE WITHIN A GOOGLE CLOUD FUNCTION INSTEAD TO OFFLOAD TO THE CLOUD INSTEAD OF LETTING THE USER DO IT ON THEIR DEVICE
        guard let username = post.postOwner else { return }
        UserStruct().readFollowers(user: username) { (followers) in
            for follower in followers {
                UserStruct().addNewContent(user: follower, link: key)
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
                guard post["dateCreated"] != nil else { return }// this just makes sure that the given post has been properly created
                let likedBy = post["likedBy"] != nil ? post["likedBy"] as! [String : String] : [:] as! [String : String]
                let contentKey = post["contentKey"] != nil ? post["contentKey"] as! String : ""
                
                let tags = post["tags"] != nil ? post["tags"] as! [String : String] : [:] as! [String : String]
                
            
                
                let thisPost = Post(isImage: post["isImage"] as! Bool, numberOfLikes: post["numberOfLikes"] as! Int, postOwner: post["postOwner"] as! String, likedBy: Array(likedBy.keys), dateCreated: post["dateCreated"] as! Double, tags: Array(tags.keys), link: post["link"] as! String, contentKey: contentKey)
                
                
                completion(thisPost)
            }
        }
    }
    ///Reads multiple posts
    func readMultiplePosts(limit: UInt, completion: @escaping([Post]) -> Void) {
        DB.queryLimited(toFirst: limit).observeSingleEvent(of: .value) { (snapshot) in
            if let listOfPosts = snapshot.value as? [String: [String: Any]] {
                var postArray: [Post] = []
                
                for post in listOfPosts.values {
                    guard post["dateCreated"] != nil else { return }// this just makes sure that the given post has been properly created
                        let likedBy = post["likedBy"] != nil ? post["likedBy"] as! [String : String] : [:] as! [String : String]
                        let contentKey = post["contentKey"] != nil ? post["contentKey"] as! String : ""
                    
                        let tags = post["tags"] != nil ? post["tags"] as! [String : String] : [:] as! [String : String]
                        let thisPost = Post(isImage: post["isImage"] as! Bool, numberOfLikes: post["numberOfLikes"] as! Int, postOwner: post["postOwner"] as! String, likedBy: Array(likedBy.keys), dateCreated: post["dateCreated"] as! Double, tags: Array(tags.keys), link: post["link"] as! String, contentKey: contentKey)
                        postArray.append(thisPost)
                }
                completion(postArray)
            }
        }
    }
    
    
    ///Reads the Admin Posts for the top caousel for the discover page
    func readAdminPosts(completion: @escaping([String]) -> Void) {
        let DB = Database.database().reference().child("AdminPosts")
        DB.observeSingleEvent(of: .value) { (snapshot) in
            
            var adminPosts:[String] = []
            
            for child in snapshot.children {
                guard let child = child as? DataSnapshot else { return }
                guard let value = child.value as? String else { return }
                adminPosts.append(value)
            }
            completion(adminPosts)
        }
        
    }
    
}
