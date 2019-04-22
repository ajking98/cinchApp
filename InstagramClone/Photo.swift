//
//  Photo.swift
//  Photos
//
//  Created by Duc Tran on 1/19/17.
//  Copyright © 2017 Developers Academy. All rights reserved.
//

import Foundation

struct PhotoCategory {
    var categoryImageName: String
    var title: String
    var imageNames: [String]
    
    static func fetchPhotos() -> [PhotoCategory] {
        var categories = [PhotoCategory]()
        let photosData = PhotosLibrary.downloadPhotosData()
        
        for (categoryName, dict) in photosData {
            if let dict = dict as? [String : Any] {
                let categoryImageName = dict["categoryImageName"] as! String
                if let imageNames = dict["imageNames"] as? [String] {
                    let newCategory = PhotoCategory(categoryImageName: categoryImageName, title: categoryName, imageNames: imageNames)
                    categories.append(newCategory)
                }
            }
        }
        
        return categories
    }
}

class PhotosLibrary
{
    class func downloadPhotosData() -> [String : Any]
    {
        return [
            "Family" : [
                "categoryImageName" : "family",
                "imageNames" : PhotosLibrary.generateImage(categoryPrefix: "f", numberOfImages: 9),
            ],
            "Foods" : [
                "categoryImageName" : "foods",
                "imageNames" : PhotosLibrary.generateImage(categoryPrefix: "fo", numberOfImages: 8),
            ],
            "Travel" : [
                "categoryImageName" : "travel",
                "imageNames" : PhotosLibrary.generateImage(categoryPrefix: "t", numberOfImages: 8),
            ],
            "Nature" : [
                "categoryImageName" : "nature",
                "imageNames" : PhotosLibrary.generateImage(categoryPrefix: "n", numberOfImages: 9),
            ]
        ]
    }
    
    private class func generateImage(categoryPrefix: String, numberOfImages: Int) -> [String] {
        var imageNames = [String]()
        
        for i in 1...numberOfImages {
            imageNames.append("\(categoryPrefix)\(i)")
        }
        
        return imageNames
    }
}








