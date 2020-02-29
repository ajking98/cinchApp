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
        let updatedLink = convertStringToKey(link: post)
        DB.child(updatedLink).child("postOwner").observeSingleEvent(of: .value) { (snapshot) in
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
        let updatedLink = convertStringToKey(link: post)

        DB.child(updatedLink).child("dateCreated").observeSingleEvent(of: .value) { (snapshot) in
            if let dateCreated = snapshot.value as? Double {
                completion(dateCreated)
            }
        }
    }
    
    func updateDateCreated(post : String, newDateCreated : Double) {
        let updatedLink = convertStringToKey(link: post)
        DB.child(updatedLink).child("dateCreated").setValue(newDateCreated)
    }
    
    
    
    /*
    likedBy
    */
    func addLikedBy(post : String, newLiker : String) {
        let updatedLink = convertStringToKey(link: post)
        DB.child(updatedLink).child("likedBy").child(newLiker).child(newLiker)
    }
    
    func deleteLikedBy(post : String, liker : String) {
        let updatedLink = convertStringToKey(link: post)
        DB.child(updatedLink).child("likedBy").child(liker).removeValue()
    }
    
    func readLikedBy(post : String, completion : @escaping([String])-> Void) {
        let updatedLink = convertStringToKey(link: post)
        DB.child(updatedLink).child("likedBy").observeSingleEvent(of: .value) { (snapshot) in
            if let likedBy = snapshot.value as? [String : String] {
                completion(Array(likedBy.keys))
            }
        }
    }
    
    
    /*
        Thumbnail
     */
     ///adds thumbnail to post at given link
     func addThumbnail(linkOfPost: String, linkToThumbnail: String) {
         let updatedLink = convertStringToKey(link: linkOfPost)
         DB.child(updatedLink).child("thumbnail").setValue(linkToThumbnail)
     }
    
    
    ///reads the thumbnail for the given post
    func readThumbnail(link: String, completion: @escaping(String) -> Void) {
        let updatedLink = convertStringToKey(link: link)
        DB.child(updatedLink).child("thumbnail").observeSingleEvent(of: .value) { (snapshot) in
            if let thumbnailLink = snapshot.value as? String {
                completion(thumbnailLink)
            }
        }
    }
    
    //TODO: this is a temporary function and should be removed once all the existing posts have a thumbnail
    ///checks if the given link has a thumbnail
    func hasThumbnail(link: String, completion: @escaping(Bool) -> Void) {
        let updatedLink = convertStringToKey(link: link)
        DB.child(updatedLink).child("thumbnail").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                print("this thumbnail does exist")
                completion(true)
            }
            else {
                print("this should create a thumbnail")
                completion(false)
            }
        }
    }
    
    
    
    /*
     Thumbnail - where the thumbnail is a series of images
     */
    
    ///adds thumbnail to post at given link
    func addThumbnail(linkOfPost: String, linkToThumbnail: [String]) {
        let updatedLink = convertStringToKey(link: linkOfPost)
        let sortedContent = linkToThumbnail.sorted()
        DB.child(updatedLink).child("thumbnail").setValue(sortedContent)
    }
    
    
    /*
    tags
    */
    ///Adds a single tag to a single post and also adds the post under the tag in DB
    func addTag(post : String, newTag : String) {
        let updatedLink = convertStringToKey(link: post)
        DB.child(updatedLink).child("tags").updateChildValues([newTag : newTag])
        let tag = Tag(tagLabel: newTag, tagElements: [TagElement(link: post)])
        ParentTagStruct().addTag(tag: tag)
    }
    
    //This doesn't add the post to the tag
    ///Adds mutliple tags at a time to a single post
    func addTags(post : String, newTags : [String]) {
        var tagDict : [String : String] = [:]
        let updatedLink = convertStringToKey(link: post)
        
        for tag in newTags {
            tagDict[tag] = tag
            let myTag = Tag(tagLabel: tag, tagElements: [TagElement(link: post)])
            ParentTagStruct().addTag(tag: myTag)
        }
        DB.child(updatedLink).child("tags").updateChildValues(tagDict)
    }
    
    func deleteTag(post : String, tag : String) {
        let updatedLink = convertStringToKey(link: post)
        DB.child(updatedLink).child("tags").child(tag).removeValue()
    }
    
    func readTags(post : String, completion : @escaping([String])-> Void) {
        let updatedLink = convertStringToKey(link: post)
        DB.child(updatedLink).child("tags").observeSingleEvent(of: .value) { (snapshot) in
            var tags: [String] = []
            for child in snapshot.children {
                let child = child as? DataSnapshot
                guard let tag = child?.value as? String else { return }
                tags.append(tag)
            }
            completion(tags)
        }
    }
}
