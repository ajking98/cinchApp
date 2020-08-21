//
//  UploadScriptVC.swift
//  Cinch
//
//  Created by Ahmed Gedi on 7/31/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit



struct Meme: Codable {
    var title: String
    var image: String
    var tags: [String]
}

class UploadScriptVC: UIViewController {
    
    let contentImageView = UIImageView()
    var tagText = ""
    var tagArray = [String]()
    
    let acceptButton = UIButton()
    let declineButton = UIButton()
    var currentIndex = 0
    let username = "Admin"
    
    let identifier = "Cell"
    var captionTableView = UITableView()
    
    var memes = [Meme]()
    
    
    ///Reads Json from file
    func parseData(){
        if let path = Bundle.main.path(forResource: "memes_part1", ofType: "json") { //Change file name
            print("the file is present")
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonOther = try? JSONDecoder().decode([Meme].self, from: data){
                    memes = jsonOther
                    setup(currentIndex)
                }
            } catch {
                 // handle error
            }
        }
    }
    
    func setup(_ index: Int) {
        tagArray = memes[index].title.components(separatedBy: " ")
        tagArray.append(contentsOf: memes[index].tags)
        
        let link = memes[index].image
        
        //image
        let url = URL(string: link)
        let data = try? Data(contentsOf: url!)

        if let imageData = data {
            let image = UIImage(data: imageData)
            contentImageView.image = image
        }
        
        captionTableView.reloadData()
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .lightGray
        
        
        //calls functions to read json file
        parseData()
        
        //TableView
        captionTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        captionTableView.dataSource = self
        captionTableView.delegate = self
        captionTableView.frame = CGRect(x: 20, y: 20, width: 200, height: 300)
        view.addSubview(captionTableView)
        
        contentImageView.frame.size = CGSize(width: 200, height: 200)
        contentImageView.center = view.center
        contentImageView.center.y += 100
        view.addSubview(contentImageView)
        
        
        //AcceptButton
        acceptButton.backgroundColor = .green
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.setTitleColor(.black, for: .normal)
        acceptButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(accept)))
        
        acceptButton.frame.size = CGSize(width: 150, height: 100)
        acceptButton.center.y = view.center.y + 300
        view.addSubview(acceptButton)
        
        //DeclineButton
        declineButton.backgroundColor = .red
        declineButton.setTitle("Reject", for: .normal)
        declineButton.setTitleColor(.black, for: .normal)
        declineButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reject)))
        
        declineButton.frame.size = CGSize(width: 150, height: 100)
        declineButton.center.y = view.center.y + 300
        declineButton.frame.origin.x = 200
        view.addSubview(declineButton)
    }
    
    @objc func accept(){
        if let image = contentImageView.image {
            if let data = image.jpegData(compressionQuality: 0.8) {
                let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
                try? data.write(to: filename)
                
                saveToFolder(localLink: filename, tagArray: tagArray)
            }
        }
        reject()
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    @objc func reject(){
        if(memes.count - 1 > currentIndex) {
            print("moving to next", currentIndex)
            currentIndex += 1
            setup(currentIndex)
        }
        
        else {
            print("reached end")
            reachedEndAlert()
        }
    }
    
    func reachedEndAlert() {
        var alert = UIAlertController(title: "Reached End", message: "no more content", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func saveToFolder(localLink: URL, tagArray: [String], _ frames: [UIImage]? = nil) {

        StorageStruct().uploadContent(mediaLink: localLink) { (link, contentKey) in
            FolderStruct().addContent(user: self.username, folderName: "Uploaded", contentKey: contentKey, link: link)
            self.addTags(link: link, tagArray: tagArray, contentKey: contentKey, frames)

            
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
    func addTags(link: String, tagArray: [String], contentKey: String, _ frames: [UIImage]? = nil){
        var post: Post?
        if checkIfVideo(link) {
            
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
        else {
            post = Post(isImage: true, postOwner: username, link: link, contentKey: contentKey)
            guard let standardPost = post else { return }
            standardPost.tags = tagArray
            ParentPostStruct().addPost(post: standardPost)
            print("here is contentKey:", contentKey)
        }
        
        for tag in tagArray {
            if tag.contains("./\\#") { continue }
            let standardTag = tag.lowercased()
            TagStruct().addElement(tagLabel: standardTag, tagElement: TagElement(link: link, contentKey: contentKey))
        }
        
    }
    
}
