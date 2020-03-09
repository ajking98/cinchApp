//
//  StorageStruct.swift
//  Cinch
/*
        Adds Images and videos to storage
            -For profile image, Folder icon, and Images/Videos to Folder
 */

import Foundation
import UIKit
import AVKit
import FirebaseDatabase
import FirebaseStorage

//TODO remove this once all the current content has a thumbnail
var tempArray = Array(0...2)

struct StorageStruct {
    
    
    ///Takes a contentKey and deletes the content completely from storage and DB
    func deleteContent(contentKey: String) {
        //Check if the contentKey given is actually a link ( this is for the older posts)
        //TODO Delete the content Completely
//        let storage = Storage.storage()
//        let storageRef = storage.reference(forURL: contentKey)
//
//        storageRef.delete { (error) in
//            if let error = error {
//                print("this is an error deleting the file: ", error)
//            }
//            else {
//                print("File deleted successfully")
//            }
//        }
    }
    
    ///Uploads local video to firebase and returns the link to the post and the contentKey
    func uploadContent(mediaLink: URL, completion: @escaping(String, String) -> Void){
        let contentKey = randomString(5)
        if checkIfVideo(mediaLink.absoluteString) {
            let storageRef = Storage.storage().reference().child("videos").child(contentKey + ".mp4")
            let data = NSData(contentsOfFile: mediaLink.path)
            storageRef.putData(data! as Data, metadata: nil) { (metadata, error) in
                print("working url")
                guard metadata != nil else {
                     return
                 }
                 if error != nil {
                     print("there is an error in url", error)
                 }

                 storageRef.downloadURL { (url, error) in
                     guard let downloadURL = url else {
                         print("error with url", error?.localizedDescription)
                         return
                     }
                     print("here is your url:", downloadURL.absoluteString)
                     completion(downloadURL.absoluteString, contentKey)
                 }
            }
        }
        else {
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: mediaLink)
            }
            catch {
                print("error")
            }
            
            let storageRef = Storage.storage().reference().child("PublicImages/" + contentKey + ".jpg")
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                guard (metadata != nil) else{
                    print("Error occurred in the upload process")
                    return
                }
                
                storageRef.downloadURL {(url, error) in
                    guard let downloadURL = url else {
                        print("Error occurred while uploading image")
                        return
                    }
                    completion(downloadURL.absoluteString, contentKey)
                }
            })
        }
    }
    
    ///Uploads an array of frames and returns an array of the links
    func uploadFrames(frames: [UIImage], _ completion: @escaping([String]) -> Void) {
        var image = UIImage()
        var links = [String]()
        let filePath = "videoThumbnails/" + randomString(5) + "_"
        var data: Data?
        let group = DispatchGroup()
        var extraChar = ""
        
        for index in 0 ..< frames.count {
            extraChar = index < 10 ? "" : "A"
            group.enter()
            data = frames[index].jpegData(compressionQuality: 0.8)
            let storageRef = Storage.storage().reference().child(filePath + extraChar + "\(index).jpg")
            storageRef.putData(data!, metadata: nil) { (metadata, error) in
                guard (metadata != nil) else{
                    print("Error occurred while uploading frames")
                    return
                }
                
                storageRef.downloadURL {(url, error) in
                    guard let downloadURL = url else {
                        print("Error occurred in uploading frames", error?.localizedDescription)
                        return
                    }
                    links.append(downloadURL.absoluteString)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(links)
        }
    }
}
