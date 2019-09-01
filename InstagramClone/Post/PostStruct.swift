//
//  PostStruct.swift
/*
 Read and Update commands for :
    isImage
    link
    numberOfLikes
    postOwner
    dateCreated
 
 Add, Read, Delete commands for :
    likedBy
    tags
 */
    
//   Created on 8/8/19.
//

import Foundation
import FirebaseDatabase


struct PostStruct {
    
    let DB = Database.database().reference().child("posts")
    
    
    /*
    isImage
    */
    func readIsImage(post : String, completion : @escaping(Bool) -> Void) {
        DB.child(post).child("isImage").observeSingleEvent(of: .value) { (snapshot) in
            if let isImage = snapshot.value as? Bool {
                completion(isImage)
            }
        }
    }
    
    
    func updateIsImage(post : String, newIsImage : Bool) {
        DB.child(post).child("isImage").setValue(newIsImage)
    }
    
    
    /*
    link
    */
    func readLink(post : String, completion : @escaping(String)->Void) {
        completion(post)
    }
    
    
    /*
    numberOfLikes
    */
    //TODO consider making it observe Single event for child changed
    func readNumberOfLikes(post : String, completion : @escaping(Int)-> Void) {
        DB.child(post).child("numberOfLikes").observeSingleEvent(of: .value) { (snapshot) in
            if let numberOfLikes = snapshot.value as? Int {
                completion(numberOfLikes)
            }
        }
    }
    
    func updateNumberOfLikes(post : String, newNumberOfLikes : Int) {
        DB.child(post).child("numberOfLikes").setValue(newNumberOfLikes)
    }
    
    
    
    
    /*
    postOwner
    */
    func readPostOwner(post : String, completion : @escaping(String)-> Void) {
        DB.child(post).child("postOwner").observeSingleEvent(of: .value) { (snapshot) in
            if let postOwner = snapshot.value as? String {
                completion(postOwner)
            }
        }
    }
    
    func updatePostOwner(post : String, newPostOwner : String) {
        DB.child(post).child("postOwner").setValue(newPostOwner)
    }
    
    
    
    /*
    dateCreated
    */
    func readDateCreated(post : String, completion : @escaping(Double)-> Void) {
        DB.child(post).child("dateCreated").observeSingleEvent(of: .value) { (snapshot) in
            if let dateCreated = snapshot.value as? Double {
                completion(dateCreated)
            }
        }
    }
    
    func updateDateCreated(post : String, newDateCreated : Double) {
        DB.child(post).child("dateCreated").setValue(newDateCreated)
    }
    
    
    
    /*
    likedBy
    */
    func addLikedBy(post : String, newLiker : String) {
        DB.child(post).child("likedBy").child(newLiker).child(newLiker)
    }
    
    func deleteLikedBy(post : String, liker : String) {
        DB.child(post).child("likedBy").child(liker).removeValue()
    }
    
    func readLikedBy(post : String, completion : @escaping([String])-> Void) {
        DB.child(post).child("likedBy").observeSingleEvent(of: .value) { (snapshot) in
            if let likedBy = snapshot.value as? [String : String] {
                completion(Array(likedBy.keys))
            }
        }
    }
    
    
    /*
    tags
    */
    func addTag(post : String, newTag : String) {
        DB.child(post).child("tags").child(newTag).child(newTag)
    }
    
    func deleteTag(post : String, tag : String) {
        DB.child(post).child("tags").child(tag).removeValue()
    }
    
    func readTags(post : String, completion : @escaping([String])-> Void) {
        DB.child(post).child("tags").observeSingleEvent(of: .value) { (snapshot) in
            if let tags = snapshot.value as? [String : String] {
                completion(Array(tags.keys))
            }
        }
    }
}
