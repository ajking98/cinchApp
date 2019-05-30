//
//  DownloadImage.swift
//  InstagramClone
//
//  Created by Alsahlani, Yassin K on 5/19/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit
import Photos

struct Download {
    
    
    //Alert user
    var alert = UIAlertController(title:"Saved", message: "Your image has been saved", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    
    var image : UIImage?
    
    mutating func downloadImage(targetImage : UIImage)-> (UIAlertController){
        
        //request access to write to camera roll
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    
                    //save image
                    UIImageWriteToSavedPhotosAlbum(targetImage, nil, nil, nil)
                }else {}
            }
        }
        else if (photos == .authorized){
            
            //save image
            UIImageWriteToSavedPhotosAlbum(targetImage, nil, nil, nil)
        }
        else {
            alert = UIAlertController(title: "Error", message: "You must grant Cinch access to your camera roll first", preferredStyle: .alert)
            
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    
                    //save image
                    UIImageWriteToSavedPhotosAlbum(targetImage, nil, nil, nil)
                }else {}
            }
        }
        
        alert.addAction(okAction)
        return alert
    }
}
