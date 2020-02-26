//
//  SuperFunctions.swift
/*
    Super functions used to execute powerful commands
 */
//  Created by Alsahlani, Yassin K on 2/26/20.

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
    
    //creates the thumbnail for an existing post
    func createThumbnail(link: String) {
        PostStruct().hasThumbnail(link: link) { (hasThumbnail) in
            
            //This is creating the thumbnail and uploads it to DB
            do {
                try time {
                    if let sourceURL = URL(string: link) {
                        let asset = AVURLAsset(url: sourceURL)
                        let trimmedAsset = try asset.assetByTrimming(timeOffStart: 1) //Only getting 1 second of the full clip
                        let playerItem = AVPlayerItem(asset: trimmedAsset)
                        StorageStruct().uploadVideo(video: playerItem) { (thumbnailLink) in
                            PostStruct().addThumbnail(linkOfPost: link, linkToThumbnail: thumbnailLink)
                        }
                    }
                }
            } catch let error {
                print("💩 \(error)")
            }
            
        }
    }
}
