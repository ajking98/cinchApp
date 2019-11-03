//
//  FolderContent.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 10/19/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit

class FolderContent: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //todo summon the imageSelectedView and pass the selected image
        print("I think are reaching", storyboard)
        let vc = UIStoryboard(name: "Discover", bundle: nil).instantiateViewController(withIdentifier: "ImageSelectedController") as! ImageSelectedController

        print("I think are reaching2")
        let link = content[indexPath.item]
        
        //TODO this creates a post using the link and uses static data in contstructor, this should instead get the data from the posts section in the database
        let post = Post(isImage: true, numberOfLikes: 41, postOwner: username, likedBy: ["someone"], dateCreated: Date().timeIntervalSince1970, tags: ["nothing"], link: link)
        
        vc.post = post
        self.present(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FolderContentCell
        cell.buildPostCard(link: content[indexPath.item])
        cell.backgroundColor = .lightGreen
        return cell
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //todo add all images to this array
    var content : [String] = [] //holds the link to each post
    var folderName = ""
    var username : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("we are building")
        if username == nil {
            username = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)
        }
        
        
        //sizes and spaces the cells
        buildCollectionView()
        
        buildExitButton() //creates an exit button and adds it to the view
        
        //retrieves the contents for a folder
        fetchContent()
    }
    
    
    ///gets posts from Firebase
    func fetchContent() {
        print("here is name:", username, "and here is foldername", folderName)
        FolderStruct().readContent(user: username, folderName: folderName) { (contentDict) in
            print("reached here")
            for (_, value) in contentDict{
                let indexPath = IndexPath(item: self.content.count, section: 0)
                self.content.append(value)
                self.collectionView.insertItems(at: [indexPath])
            }
        }
    }
    
    func buildExitButton() {
        let width = view.frame.width
        let height = view.frame.height
        let exitButton = UIButton(frame: CGRect(x: 20, y: height * 0.75, width: width / 1.5, height: width / 6))
        exitButton.setTitle("exit", for: .normal)
        exitButton.backgroundColor = .purple
        print("reached: ", exitButton.frame)
        exitButton.center.x = view.center.x
        exitButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleExit)))
        view.addSubview(exitButton)
    }
    
    
    @objc func handleExit(_ tapGesture : UITapGestureRecognizer? = nil) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //sizes and spaces the cells
    func buildCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let screenWidth = collectionView.frame.width - 3
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        collectionView!.collectionViewLayout = layout
        collectionView.showsVerticalScrollIndicator = false
    }
    
}
