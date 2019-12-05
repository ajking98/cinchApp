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
func saveImage(imageName: String, linkToImage: URL)->URL? {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
    let data = NSData(contentsOf: linkToImage)
    let fileURL = documentsDirectory.appendingPathComponent(imageName)
    
    //Checks if file exists, removes it if so
    if FileManager.default.fileExists(atPath: fileURL.path) {
        do {
            try FileManager.default.removeItem(atPath: fileURL.path)
            print("Removed old image")
        } catch let removeError {
            print("couldn't remove image at path", removeError)
        }
    }
    
    do {
        try data?.write(to: fileURL)
    } catch let error {
        print("error saving image with error", error)
    }
    return fileURL
}



///saves the video locally, to the user's device, before being sent over
func saveVideo(videoName: String, linkToVideo: URL)->URL? {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
    let data = NSData(contentsOf: linkToVideo)
    let fileURL = documentsDirectory.appendingPathComponent(videoName)
    
    //Checks if file exists, removes it if so
    if FileManager.default.fileExists(atPath: fileURL.path) {
        do {
            try FileManager.default.removeItem(atPath: fileURL.path)
            print("Removed old video")
        } catch let removeError {
            print("couldn't remove file at path", removeError)
        }
    }
    
    do {
        try data?.write(to: fileURL)
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
