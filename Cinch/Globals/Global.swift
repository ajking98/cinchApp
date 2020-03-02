//
//  Global.swift
//  Cinch
//
//  Created by Gedi on 8/3/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit
import ImageIO
import AVKit


public enum constants: CGFloat {
    case baseVelocity = 820.0
}


func getAllFrames(videoUrl : URL, completion: @escaping([UIImage]) -> Void) {
   var frames:[UIImage] = []
   var generator: AVAssetImageGenerator?
   let asset:AVAsset = AVAsset(url: videoUrl)
   let duration:Float64 = CMTimeGetSeconds(asset.duration)
   generator = AVAssetImageGenerator(asset:asset)
   generator?.appliesPreferredTrackTransform = true
    generator?.requestedTimeToleranceAfter = CMTime.zero
    generator?.requestedTimeToleranceBefore = CMTime.zero
    
    var times = [NSValue]()
    let limit = duration < 1.5 ? duration : 1.5
    for time in 0 ..< Int(limit * 10) {
        let cmTime = CMTimeMakeWithSeconds(Double(time) / 10.0, preferredTimescale: 600)
        times.append(NSValue(time: cmTime))
    }
    
    generator?.generateCGImagesAsynchronously(forTimes: times, completionHandler: { (requestedTime, frame, actualTime, result, error) in
        DispatchQueue.main.async {
            if let frame = frame {
                frames.append(UIImage(data: UIImage(cgImage: frame).jpegData(compressionQuality: 0.1)!)!)
            }
            if frames.count == 15 {
                completion(frames)
            }
        }
    })
}


func isQuickSwipe(velocity : CGFloat) -> Bool {
    if abs(velocity) > constants.baseVelocity.rawValue {
        return true
    }
    return false
}

///updates y-axis of view by given translation
//func followFingerVertical(view : UIView, translation : CGPoint) {
//    view.center.y += translation.y
//}

///Takes in a string to a link and updates to a new value that could be used in the key place on Firebase
func convertStringToKey(link : String) -> String {
    var updatedLink = ""   //Updating the link of the url because firebase doesn't take "." in the key
    for index in link {
        if (index == ".") {
            updatedLink.append("`")
        }
        else if(index == "/") {
            updatedLink.append("^")
        }else {
            updatedLink.append(index)
        }
    }
    return updatedLink
}

///saves the video from an asset locally
func saveVideo(videoName: String, asset: AVAsset, completion: @escaping(URL) -> Void) {
    let exportPath = NSTemporaryDirectory().appending("/\(videoName).mov")
    let exportURL = URL(fileURLWithPath: exportPath)
    let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
    
    //Checks if file exists, removes it if so
    if FileManager.default.fileExists(atPath: exportURL.path) {
         do {
            try FileManager.default.removeItem(atPath: exportURL.path)
             print("Removed old video")
         } catch let removeError {
             print("couldn't remove file at path", removeError)
         }
     }
    
    
    exporter?.outputURL = exportURL
    exporter?.outputFileType = .mov
    exporter?.exportAsynchronously(completionHandler: {
        print("this is the result", exportURL)
        completion(exportURL)
    })
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


///saves the image locally, to the user's device, before being sent over
func saveImage(imageName: String, linkToImage: URL)->URL? {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
    guard let fetchedImageData = NSData(contentsOf: linkToImage) else { return URL(fileURLWithPath: "") }
    let image = UIImage(data: fetchedImageData as Data)?.resizeImage(targetSize: CGSize(width: 400, height: 400))
    let data = image?.pngData()
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



//todo this should better done 
///Returns true if the given link is a video
func checkIfVideo(_ link : String) -> Bool {
    let standardLink = link.lowercased()
    return standardLink.contains(".mp4") || standardLink.contains(".mov")
}



///returns true if the username passed is the local user
func checkIfLocalUser(username: String) -> Bool {
    guard let localUser = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey) else { return false }
    return (localUser == username) || (username == "")
}

func randomString(_ length: Int) -> String {
    let letters : NSString = "asdfghjkloiuytrewqazxcvbnmWERTYUIASDFGHJKXCVBN!@%^&*()_+=-"
    let len = UInt32(letters.length)
    
    var randomString = ""
    
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    
    return randomString
}


///Adds the video to the given uiview
func addPlayer(view: UIView, playerItem : AVPlayerItem)-> AVPlayerLayer {
    let player = AVPlayer(playerItem: playerItem)
    let playerLayer = AVPlayerLayer(player: player)
    playerLayer.videoGravity = .resizeAspectFill
    view.layer.addSublayer(playerLayer)
    playerLayer.frame = view.bounds
    player.play()
    player.isMuted = true
    loopVideo(videoPlayer: player)
    return playerLayer
}

///Assigns an NSObject to a UIView 
func setContent(view: UIView, content: NSObject) {
    if let video = content as? AVPlayerItem {
        addPlayer(view: view, playerItem: video)
    }
    else if let image = content as? UIImage {
        guard let imageView = view as? UIImageView else { return }
        imageView.image = image
    }
}


///keeps the video in a constant loop
func loopVideo(videoPlayer: AVPlayer) {
    NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
        videoPlayer.seek(to: CMTime.zero)
        videoPlayer.play()
    }
}


///Creates a thumbnail for a given video asset
func createThumbnailOfVideo(asset: AVAsset) -> UIImage? {
    let assetImgGenerate = AVAssetImageGenerator(asset: asset)
    assetImgGenerate.appliesPreferredTrackTransform = true
    //Can set this to improve performance if target size is known before hand
    //assetImgGenerate.maximumSize = CGSize(width,height)
    let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
    do {
        let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
        let thumbnail = UIImage(cgImage: img)
        return thumbnail
    } catch {
      print(error.localizedDescription)
      return nil
    }
}
