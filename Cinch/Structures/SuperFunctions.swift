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
        
        
        post.tags?.forEach({ (SingleTag) in
            TagStruct().deleteElement(tagLabel: SingleTag, contentKey: contentKey)
        })

        ParentPostStruct().deletePost(contentKey: contentKey)
        StorageStruct().deleteContent(contentKey: contentKey)
    }
    
}
