//
//  ImageInsta.swift
//  Cinch
//
//  Created by Gedi, Ahmed M on 4/19/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import FirebaseDatabase


struct ImageInsta {
    let key:String!
    let url:String!
    
    let itemRef:DatabaseReference?
    
    init(url:String, key:String) {
        self.key = key
        self.url = url
        self.itemRef = nil
    }
    
    init(snapshot:DataSnapshot) {
        key = snapshot.key
        itemRef = snapshot.ref
        
        let snapshotValue = snapshot.value as? NSDictionary
        
        if let imageUrl = snapshotValue?["url"] as? String {
            url = imageUrl
        } else {
            url = ""
        }
    }
    
    
}
