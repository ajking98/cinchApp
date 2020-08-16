//
//  UploadScriptVC.swift
//  Cinch
//
//  Created by Ahmed Gedi on 7/31/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit


class UploadScriptVC: UIViewController {
    
    //static data
    let links = ["https://www.indiewire.com/wp-content/uploads/2019/11/960x0-2.jpg", "https://ichef.bbci.co.uk/images/ic/704xn/p072ms6r.jpg"]
    let captionList = ["Funny Yoda Baby Starwars", "There was a spider its gone now"]
    
    let contentImageView = UIImageView()
    let captionText = UILabel()
    
    let acceptButton = UIButton()
    let declineButton = UIButton()
    var currentIndex = 0
    let username = "Admin"
    
    
    override func viewDidLoad() {
        view.backgroundColor = .lightGray
        setup(link: links[0], tag: captionList[0])
        
        
        contentImageView.frame.size = CGSize(width: 200, height: 200)
        contentImageView.center = view.center
        view.addSubview(contentImageView)
        
        
        //caption setup
        captionText.frame.size = CGSize(width: view.frame.width, height: 100)
        captionText.numberOfLines = 0
        captionText.frame.origin.x = 24
        view.addSubview(captionText)
        
        
        
        //AcceptButton
        acceptButton.backgroundColor = .green
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.setTitleColor(.black, for: .normal)
        acceptButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(accept)))
        
        acceptButton.frame.size = CGSize(width: 200, height: 100)
        acceptButton.center.y = view.center.y + 300
        view.addSubview(acceptButton)
        
        //DeclineButton
        declineButton.backgroundColor = .red
        declineButton.setTitle("Reject", for: .normal)
        declineButton.setTitleColor(.black, for: .normal)
        declineButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reject)))
        
        declineButton.frame.size = CGSize(width: 200, height: 100)
        declineButton.center.y = view.center.y + 300
        declineButton.frame.origin.x = 210
        view.addSubview(declineButton)
    }
    
    
    func setup(link: String, tag: String) {
        
        //image
        let url = URL(string: link)
        let data = try? Data(contentsOf: url!)

        if let imageData = data {
            let image = UIImage(data: imageData)
            contentImageView.image = image
        }
        
        
        //Tags
        captionText.text = tag
    }
    
    @objc func accept(){
        
        if let image = contentImageView.image {
            if let data = image.jpegData(compressionQuality: 0.8) {
                let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
                try? data.write(to: filename)

                print("this is going to DB", filename)
                print("compare:", getDocumentsDirectory())
                
                
                saveToFolder(localLink: filename, tags: captionText.text ?? "")
            }
        }
        
        //Calls the reject method to move to next content
        reject()
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    
    @objc func reject(){
        print("Rejected")
        if(links.count - 1 > currentIndex) {
            currentIndex += 1
            setup(link: links[currentIndex], tag: captionList[currentIndex])
        }
        
        else {
            reachedEndAlert()
        }
    }
    
    func reachedEndAlert() {
        var alert = UIAlertController(title: "Reached End", message: "no more content", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func saveToFolder(localLink: URL, tags: String, _ frames: [UIImage]? = nil) {

        StorageStruct().uploadContent(mediaLink: localLink) { (link, contentKey) in
            FolderStruct().addContent(user: self.username, folderName: "Uploaded", contentKey: contentKey, link: link)
                self.addTags(link: link, tags: tags, contentKey: contentKey, frames)

            
            //user feedback alert
                let alert = UIAlertController(title: "Upload Complete!", message: "", preferredStyle: .alert)
                let alertExpiration = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: alertExpiration) {
                    alert.dismiss(animated: true, completion: nil)
                }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    ///Adds the tags and uploads the post and the tags
    func addTags(link: String, tags: String, contentKey: String, _ frames: [UIImage]? = nil){
        let message = tags.components(separatedBy: CharacterSet(charactersIn: " ./\\#"))
        var tagArray = [String]()
        var post: Post?
        if checkIfVideo(link) {
                for tag in message{
                    if tag.count > 2 {
                        let standardizedTag = tag.lowercased()
                        tagArray.append(standardizedTag)
                    }
                }
            
        ///Adding the frames if its a video
            if let frames = frames {
                StorageStruct().uploadFrames(frames: frames) { (links) in
                    post = Post(isImage: false, postOwner: self.username, link: link, contentKey: contentKey, links)
                    guard let standardPost = post else { return }
                    standardPost.tags = tagArray
                    ParentPostStruct().addPost(post: standardPost)
                }
            }
        }
        else { //If image
            
            for tag in message{
                if tag.count > 2 {
                    let standardizedTag = tag.lowercased()
                    tagArray.append(standardizedTag)
                }
            }
            post = Post(isImage: true, postOwner: username, link: link, contentKey: contentKey)
            guard let standardPost = post else { return }
            standardPost.tags = tagArray
            ParentPostStruct().addPost(post: standardPost)
            
        }
        
        for tag in tagArray {
            TagStruct().addElement(tagLabel: tag, tagElement: TagElement(link: link, contentKey: contentKey))
        }
        
    }
}
