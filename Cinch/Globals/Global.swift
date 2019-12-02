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


//todo this should better done 
///Returns true if the given link is a video
func checkIfVideo(link : String) -> Bool {
    return link.contains(".mp4") || link.contains(".mov")
}

func randomString(_ length: Int) -> String {
    let letters : NSString = "asdfghjkloiuytrewqazxcvbnmWERTYUIASDFGHJKXCVBN!@#$%^&*()_+=-"
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
func addPlayer(view: UIView, playerItem : AVPlayerItem) {
    let player = AVPlayer(playerItem: playerItem)
    let playerLayer = AVPlayerLayer(player: player)
    playerLayer.videoGravity = .resize
    view.layer.addSublayer(playerLayer)
    playerLayer.frame = view.bounds
    player.play()
    player.isMuted = true
    loopVideo(videoPlayer: player)
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
