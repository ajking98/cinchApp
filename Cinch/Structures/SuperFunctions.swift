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
    
        UserStruct().readFolders(user: postOwner) { (folders) in
            for folder in folders {
                FolderStruct().readContent(user: postOwner, folderName: folder) { (content) in
                    content.forEach { (mediaLink) in
                        if link == mediaLink {
                            FolderStruct().deleteContent(user: postOwner, folderName: folder, link: link)
                        }
                    }
                }
            }
        }
        
        
        post.tags?.forEach({ (SingleTag) in
            TagStruct().deleteElement(tagLabel: SingleTag, link: link)
        })

        ParentPostStruct().deletePost(postLink: link)
        StorageStruct().deleteContent(link: link)
    }
    
    
    
    
    
    
    //creates the thumbnail for an existing post and adds sets the value of thumbnail for the post to the links of the images
    func createThumbnail(link: String) {
        PostStruct().hasThumbnail(link: link) { (hasThumbnail) in
            guard let url = URL(string: link) else { return }
            getAllFrames(videoUrl: url) { (thumbnail) in
                StorageStruct().uploadFrames(frames: thumbnail) { (linkToThumbnail) in
                    PostStruct().addThumbnail(linkOfPost: link, linkToThumbnail: linkToThumbnail)
                }
            }
            
        }
    }
}
