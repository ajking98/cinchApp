//
//  userStruct.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 5/24/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct userStruct {
    let key:String!
    let user:Dictionary<String, Any>
    
    let itemRef:DatabaseReference?
    
    init(key:String, user:Dictionary<String, Any>) {
        self.key = key
        self.user = user
        self.itemRef = nil
    }
    
//    init(snapshot:DataSnapshot) {
//        key = snapshot.key
//        itemRef = snapshot.ref
//
//        let snapshotValue = snapshot.value as? NSDictionary
//
//    }
}
