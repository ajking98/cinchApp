//
//  FolderContent.swift
//  Cinch
//
//  Created by Ahmed Gedi on 10/19/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class FolderContent: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //todo add all images to this array
    var content : [String] = [] //holds the link to each post
    var folderName = ""
    var username = ""
    var isLocalUser = true
    var followButton : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("we are building")
        if username == "" {
            username = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!
        }
        if !isLocalUser {
            buildFollowButton()
        }
        
        //sizes and spaces the cells
        buildCollectionView()
        
        buildExitButton() //creates an exit button and adds it to the view
        
        //retrieves the contents for a folder
        fetchContent()
    }
    
    
    func buildFollowButton() {
        let width = view.frame.width
        let height = view.frame.height
        let tempUser = String(UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!)

    
        followButton = UIButton(frame: CGRect(x: 20, y: height * 0.65, width: width / 1.5, height: width / 6))
        guard let followButton = followButton else { return }
        followButton.setTitle("Follow +", for: .normal)
        followButton.setTitleColor(.white, for: .normal)
        followButton.backgroundColor = .darkerGreen
        print("reached: ", followButton.frame)
        followButton.center.x = view.center.x
        
        //if the user already follows the folder, then disable the "follow" button
        UserStruct().readFoldersReference(user: tempUser) { (folderReferences) in
            for folderReference in folderReferences {
                if folderReference.admin == self.username && folderReference.folderName == self.folderName { //checks if the user is already following that folder
                    self.followButton?.isEnabled = false
                    self.followButton?.backgroundColor = .darkGray
                    self.followButton?.layer.opacity = 0.7
                }
            }
        }
        followButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFolderFollow)))
        view.addSubview(followButton)
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
    
    ///Adds the folder to the local user's folder reference list
    @objc func handleFolderFollow() {
        let tempUser = String(UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!)
        let folderRef = FolderReference(admin: username, folderName: folderName)
        
        self.followButton?.isEnabled = false
        self.followButton?.backgroundColor = .darkGray
        self.followButton?.layer.opacity = 0.7
        UserStruct().addFolderReference(user: tempUser, newFolder: folderRef)
        
        let alert = UIAlertController(title: "Following", message: "You are now following this folder", preferredStyle: .alert)
        present(alert, animated: true) {
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose)))
        }
    }
    
    @objc func alertClose(gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
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
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let screenWidth = collectionView.frame.width - 3
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        collectionView!.collectionViewLayout = layout
        collectionView.showsVerticalScrollIndicator = false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderContentCell", for: indexPath) as! FolderContentCell
        cell.buildPostCard(link: content[indexPath.item])
        cell.backgroundColor = .lightGreen
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let link = content[indexPath.item]
        let url = URL(string: link)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "FolderImageZoomController") as! FolderImageZoomController
        if link.contains("mp4") {
            vc.isImage = false
            vc.link = link
        } else {
            let imageView = UIImageView()
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
            print(imageView.image)
            vc.image = imageView.image!
        }
        
        let myNav = UINavigationController(rootViewController: vc)
        present(myNav, animated: true, completion: nil)
        
//        let vc = storyboard?.instantiateViewController(withIdentifier: "FolderImageZoomController") as? FolderImageZoomController
//        let imageView = UIImageView()
//        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
//        vc!.imageView?.image = imageView.image
//        self.performSegue(withIdentifier: "segueWithData", sender: self)
    }
    
}
