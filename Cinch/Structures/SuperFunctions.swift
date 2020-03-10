//
//  SuperFunctions.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 3/5/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import AVKit


struct SuperFunctions {
    
    //TODO Delete the thumbnail if it exists
    ///Deletes the post and all its elements from storage and DB
    func permanentlyDeletePost(post : Post) {
        let postOwner = post.postOwner ?? ""
        let link = post.link ?? ""
        
        let contentKey = post.contentKey.count > 1 ? post.contentKey : link
    
        UserStruct().readFolders(user: postOwner) { (folders) in
            for folder in folders {
                FolderStruct().readContent(user: postOwner, folderName: folder) { (content) in
                    content.forEach { (mediaLink) in
                        if contentKey == mediaLink {
                            FolderStruct().deleteContent(user: postOwner, folderName: folder, contentKey: contentKey)
                        }
                    }
                }
            }
        }
        
        if let thumbnail = post.thumbnail {
            for imageLink in thumbnail {
                print("here is a link to check: ", imageLink)
                StorageStruct().deleteContent(link: imageLink)
            }
        }
        
        
        post.tags?.forEach({ (SingleTag) in
            print("this is the content Key: ", contentKey)
            TagStruct().deleteElement(tagLabel: SingleTag, contentKey: contentKey)
            TagStruct().deleteElement(tagLabel: SingleTag, contentKey: link)
        })
        
        print("is a link: ", link)
        ParentPostStruct().deletePost(contentKey: contentKey)
        StorageStruct().deleteContent(link: link)
    }
    
    func createThumbnail(contentKey: String) {
        //This is creating the thumbnail and uploads it to DB
        PostStruct().readLink(contentKey: contentKey) { (link) in
            guard let url = URL(string: link) else { return }
            getAllFrames(videoUrl: url, completion: {(frames) in
                print("this is the count of the images: ", frames.count)
                
                StorageStruct().uploadFrames(frames: frames) { (links) in
                    PostStruct().addThumbnail(contentKey: contentKey, linkToThumbnail: links)
                    print("just added the thumbnail")
                }
            })
        }
    }
    
}
