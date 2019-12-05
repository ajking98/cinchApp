//
//  iMessageGlobal.swift
//  CinchIMessageExtension
//
//  Created by Alsahlani, Yassin K on 12/4/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit
import AVKit


///saves the image locally, to the user's device, before being sent over
func saveImage(imageName: String, image: UIImage)->URL? {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
    
    guard let data = image.jpegData(compressionQuality: 1) else { return nil }
    
    let fileName = imageName
    let fileURL = documentsDirectory.appendingPathComponent(fileName)
    
    //Checks if file exists, removes it if so.
    if FileManager.default.fileExists(atPath: fileURL.path) {
        do {
            try FileManager.default.removeItem(atPath: fileURL.path)
            print("Removed old image")
        } catch let removeError {
            print("couldn't remove file at path", removeError)
        }
    }
    
    do {
        try data.write(to: fileURL)
    } catch let error {
        print("error saving file with error", error)
    }
    return fileURL
}



//TODO fix saving video
///saves the video locally, to the user's device, before being sent over
func saveVideo(videName: String, video: AVPlayer)->URL? {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
    let data = NSData(contentsOf: URL(string: videName)!)
    let fileName = videName
    let fileURL = documentsDirectory.appendingPathComponent(fileName)
    
    //Checks if file exists, removes it if so.
    if FileManager.default.fileExists(atPath: fileURL.path) {
        do {
            try FileManager.default.removeItem(atPath: fileURL.path)
            print("Removed old video")
        } catch let removeError {
            print("couldn't remove file at path", removeError)
        }
    }
    
    do {
        try data!.write(to: fileURL)
    } catch let error {
        print("error saving file with error", error)
    }
    return fileURL
}



func designCell(cell: MessageCard) {
    cell.layer.borderWidth = 1
    cell.layer.borderColor = UIColor.white.cgColor
    cell.clipsToBounds = true
}
