//
//  iMessageGlobals.swift
//  iMessage
//
//  Created by Alsahlani, Yassin K on 2/11/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit



///takes a global link to the content content, then saves it and returns a local url to the location
func saveContent(globalLink: String) -> URL? {
       guard let url = URL(string: globalLink) else { return nil } //converts the link to an actual url
       var directory:URL?

       if (checkIfVideo(globalLink)) { //handle video
           directory = (saveVideo(videoName: "SelectedVideo.mp4", linkToVideo: url))
       }
       else { //handle image
           if (globalLink.contains("/videos")) { return nil } //checking to make sure the content is not a video
           directory = saveImage(imageName: "SelectedImage.jpg", linkToImage: url)
       }
       guard directory != nil else { return nil }
    
    return directory
}



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



