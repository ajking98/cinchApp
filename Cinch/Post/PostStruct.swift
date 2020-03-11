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
    ///Returns the value of whether or not the post is an image
    func readIsImage(contentKey : String, completion : @escaping(Bool) -> Void) {
        DB.child(contentKey).child("isImage").observeSingleEvent(of: .value) { (snapshot) in
            if let isImage = snapshot.value as? Bool {
                completion(isImage)
            }
        }
    }
    
    ///Sets the value of post's isImage to the boolean value given
    func updateIsImage(contentKey : String, newIsImage : Bool) {
        DB.child(contentKey).child("isImage").setValue(newIsImage)
    }
    
    
    /*
    link
    */
    
    ///takes a contentKey and returns the link to the content
    func readLink(contentKey : String, completion : @escaping(String)->Void) {
        DB.child(contentKey).child("link").observeSingleEvent(of: .value) { (snapshot) in
            if let link = snapshot.value as? String {
                completion(link)
            }
        }
    }
    
    
    /*
    numberOfLikes
    */
    //TODO consider making it observe Single event for child changed
    func readNumberOfLikes(contentKey : String, completion : @escaping(Int)-> Void) {
        DB.child(contentKey).child("numberOfLikes").observeSingleEvent(of: .value) { (snapshot) in
            if let numberOfLikes = snapshot.value as? Int {
                completion(numberOfLikes)
            }
        }
    }
    
    
    ///updates the number of likes for the post to the given value
    func updateNumberOfLikes(contentKey : String, newNumberOfLikes : Int) {
        DB.child(contentKey).child("numberOfLikes").setValue(newNumberOfLikes)
    }
    
    
    
    
    /*
    postOwner
    */
    
    ///Takes a contentKey and returns the post owner
    func readPostOwner(contentKey : String, completion : @escaping(String)-> Void) {
        let updatedLink = convertStringToKey(link: contentKey)
        DB.child(updatedLink).child("postOwner").observeSingleEvent(of: .value) { (snapshot) in
            if let postOwner = snapshot.value as? String {
                completion(postOwner)
            }
        }
    }
    
    ///updates the post owner for the post to the given value
    func updatePostOwner(contentKey : String, newPostOwner : String) {
        DB.child(contentKey).child("postOwner").setValue(newPostOwner)
    }
    
    
    
    /*
    dateCreated
    */
    ///takes a contentKey and returns the date the post was created
    func readDateCreated(contentKey : String, completion : @escaping(Double)-> Void) {
        let updatedLink = convertStringToKey(link: contentKey)

        DB.child(updatedLink).child("dateCreated").observeSingleEvent(of: .value) { (snapshot) in
            if let dateCreated = snapshot.value as? Double {
                completion(dateCreated)
            }
        }
    }
    
    ///updates the date created of the post to the given date
    func updateDateCreated(contentKey : String, newDateCreated : Double) {
        let updatedLink = convertStringToKey(link: contentKey)
        DB.child(updatedLink).child("dateCreated").setValue(newDateCreated)
    }
    
    
    
    /*
    likedBy
    */
    ///Adds a user to the likedBy array for the given post
    func addLikedBy(contentKey : String, newLiker : String) {
        let updatedLink = convertStringToKey(link: contentKey)
        DB.child(updatedLink).child("likedBy").child(newLiker).child(newLiker)
    }
    
    ///Deletes a user from the liked by array
    func deleteLikedBy(contentKey : String, liker : String) {
        let updatedLink = convertStringToKey(link: contentKey)
        DB.child(updatedLink).child("likedBy").child(liker).removeValue()
    }
    
    
    ///reads the users that have liked the post
    func readLikedBy(contentKey : String, completion : @escaping([String])-> Void) {
        let updatedLink = convertStringToKey(link: contentKey)
        DB.child(updatedLink).child("likedBy").observeSingleEvent(of: .value) { (snapshot) in
            if let likedBy = snapshot.value as? [String : String] {
                completion(Array(likedBy.keys))
            }
        }
    }
    
    
    /*
        Thumbnail
     */
    
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
    
    ///adds thumbnail to post at given contentKey
    func addThumbnail(contentKey: String, linkToThumbnail: [String]) {
        let updatedLink = convertStringToKey(link: contentKey)
        let sortedContent = linkToThumbnail.sorted()
        DB.child(updatedLink).child("thumbnail").setValue(sortedContent)
    }
    
    
    ///reads the thumbnail for the given post
    func readThumbnail(contentKey: String, completion: @escaping([URL]) -> Void) {
        let updatedLink = convertStringToKey(link: contentKey)
        DB.child(updatedLink).child("thumbnail").observeSingleEvent(of: .value) { (snapshot) in
            var urls: [URL] = []
            for child in snapshot.children {
                guard let child = child as? DataSnapshot else { return }
                guard let value = child.value as? String else { return }
                if let url = URL(string: value) {
                    urls.append(url)
                }
            }
            completion(urls)
        }
    }
    
    
    /*
    tags
    */
    ///Adds a single tag to a single post and also adds the post under the tag in DB
    func addTag(post : String, contentKey: String, newTag : String) {
        let updatedLink = convertStringToKey(link: contentKey)
        DB.child(updatedLink).child("tags").updateChildValues([newTag : newTag])
        let tag = Tag(tagLabel: newTag, tagElements: [TagElement(link: post, contentKey: contentKey)])
        ParentTagStruct().addTag(tag: tag)
    }
    
    //This doesn't add the post to the tag
    ///Adds mutliple tags at a time to a single post
//    func addTags(post : String, contentKey: String, newTags : [String]) {
//        var tagDict : [String : String] = [:]
//        let updatedLink = convertStringToKey(link: post)
//
//        for tag in newTags {
//            tagDict[tag] = tag
//            let myTag = Tag(tagLabel: tag, tagElements: [TagElement(link: post, contentKey: contentKey)])
//            ParentTagStruct().addTag(tag: myTag)
//        }
//        DB.child(updatedLink).child("tags").updateChildValues(tagDict)
//    }
    
    
    ///deletes the tag term from post
    func deleteTag(contentKey: String, tag: String) {
        let updatedLink = convertStringToKey(link: contentKey)
        DB.child(updatedLink).child("tags").child(tag).removeValue()
    }
    
    ///reads the tags for the given post
    func readTags(contentKey: String, completion: @escaping([String])-> Void) {
        let updatedLink = convertStringToKey(link: contentKey)
        print("thisis you updated Link sonny", updatedLink)
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
