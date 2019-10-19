//
//  FolderContent.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 10/19/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit

class FolderContent: UICollectionViewController{
    var content : [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    ///gets posts from Firebase
    func grabContent() {
        
//        FolderStruct().readContent(user: <#T##String#>, folderName: <#T##String#>, completion: <#T##([String : String]) -> Void#>)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }
}
