//
//  CellSelectedController.swift
//  Cinch
/*
    1. Add fullscreen image
    2. Add Back button
    3. Add right hand side
    4. Add hashtags
    5. Put it in a tableView
*/
//  Created by Alsahlani, Yassin K on 1/27/20.

import UIKit
import Kingfisher

class CellSelectedCell: UITableViewCell{
    
    //data
    var link = ""
    var username = ""
    var handlePresentProfile: ((String) -> Void)?
    
    var fullScreenImageView = UIImageView(frame: CGRect.zero)
    let shareIcon = UIImageView(image: UIImage(named: "shareIcon"))
    let heartIcon = UIImageView(image: UIImage(named: "heartIcon"))
    let followUserIcon = UIImageView(image: UIImage(named: "followUserIcon"))
    var profileIcon = UIImageView(frame: CGRect.zero)
    let lowerText = UILabel(frame: CGRect.zero)
    
    
    //TODO: Remove this
    let xMark = UIButton(type: .contactAdd)
    var post = Post(isImage: true, numberOfLikes: 0, postOwner: "ohSHoot", likedBy: [], dateCreated: 0, tags: [], link: "")
    
    func setup(link: String) {
        
        post.link = link
        PostStruct().readPostOwner(post: link) { (author) in
            self.post.postOwner = author
        }
        
        PostStruct().readTags(post: link) { (tags) in
            self.post.tags = tags
        }
        
        
        
        self.link = link
        username = "nil"
        fetchContent()
        setupFullScreenImageView()
        setupRightHandView()
        setupLowerText()
        setupxMark()
    }
    
    func setupxMark() {
        xMark.addTarget(self, action: #selector(handleRemoved), for: .touchUpInside)
        xMark.frame = CGRect(x: 200, y: 200, width: 50, height: 50)
        xMark.backgroundColor = .green
        xMark.isHidden = true //TODO remove this to be able to delete posts
        addSubview(xMark)
    }
    
    @objc func handleRemoved() {
        
        
        UserStruct().readFolders(user: self.username) { (folders) in
            for folder in folders {
                FolderStruct().readContent(user: self.username, folderName: folder) { (content) in
                    content.forEach { (link) in
                        if link == self.link {
                            print("this is the folder we are deleting from: ", folder)
                            FolderStruct().deleteContent(user: self.username, folderName: folder, link: link)
                        }
                    }
                }
            }
        }
        post.tags?.forEach({ (SingleTag) in
            TagStruct().deleteElement(tagLabel: SingleTag, link: self.link)
        })

        ParentPostStruct().deletePost(postLink: link)
        StorageStruct().deleteContent(link: link)
        print("the user is: \(username), this is being removed", link)
    }
    
    override func prepareForReuse() {
        username = "nil"
        profileIcon.image = UIImage()
        fullScreenImageView = UIImageView()
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
    
    func fetchContent() {
        if checkIfVideo(link) {
            guard let link = URL(string: link) else { return }
            let playerLayer = fullScreenImageView.loadVideo(link, size: frame.size)
            playerLayer.videoGravity = .resizeAspect
        }
        else {
            fullScreenImageView.sd_setImage(with: URL(string: link), placeholderImage: UIImage(), completed: nil)
        }
        PostStruct().readPostOwner(post: link) { (author) in
            self.username = author
            
            UserStruct().readProfilePic(user: author) { (profilePic) in
                self.profileIcon.sd_setImage(with: URL(string: profilePic), placeholderImage: UIImage(), completed: nil)
            }
        }
        PostStruct().readTags(post: link) { (tags) in
            self.lowerText.text = ""
            for tag in tags {
                self.lowerText.text? += "#\(tag) "
            }
        }
    }
    
    //full screen imageview
    func setupFullScreenImageView(){
        backgroundColor = .black
        addSubview(fullScreenImageView)
        
        //constraints
        fullScreenImageView.translatesAutoresizingMaskIntoConstraints = false
        fullScreenImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        fullScreenImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        fullScreenImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        fullScreenImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        //Main Content
        fullScreenImageView.contentMode = .scaleAspectFit
        
    }
    
    
    func setupRightHandView() {
        //share icon
        addSubview(shareIcon)
        shareIcon.translatesAutoresizingMaskIntoConstraints = false
        shareIcon.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        shareIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0.31 * frame.height).isActive = true
        
        
        //heart icon
        addSubview(heartIcon)
        heartIcon.translatesAutoresizingMaskIntoConstraints = false
        heartIcon.centerXAnchor.constraint(equalTo: shareIcon.centerXAnchor).isActive = true
        heartIcon.bottomAnchor.constraint(equalTo: shareIcon.topAnchor, constant: -20).isActive = true
        
        
        //profile icon
        profileIcon.backgroundColor = .lightGray
        
        addSubview(profileIcon)
        profileIcon.translatesAutoresizingMaskIntoConstraints = false
        profileIcon.centerXAnchor.constraint(equalTo: heartIcon.centerXAnchor).isActive = true
        profileIcon.bottomAnchor.constraint(equalTo: heartIcon.topAnchor, constant: -25).isActive = true
        profileIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        profileIcon.layer.cornerRadius = 20
        profileIcon.clipsToBounds = true
        profileIcon.isUserInteractionEnabled = true
        profileIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfilePicPressed)))
        
        
        //follow user icon
        addSubview(followUserIcon)
        followUserIcon.translatesAutoresizingMaskIntoConstraints = false
        followUserIcon.centerYAnchor.constraint(equalTo: profileIcon.bottomAnchor).isActive = true
        followUserIcon.centerXAnchor.constraint(equalTo: profileIcon.centerXAnchor).isActive = true
    }
    
    @objc func handleProfilePicPressed() {
        //push using navigation
        guard let handlePresentProfile = handlePresentProfile else { return }
        handlePresentProfile(username)
        
    }
    
    func setupLowerText() {
        lowerText.textColor = .lightGray
        addSubview(lowerText)
        lowerText.font.withSize(13)
        lowerText.numberOfLines = 0
        lowerText.translatesAutoresizingMaskIntoConstraints = false
        lowerText.leftAnchor.constraint(equalTo: leftAnchor, constant: 17.5).isActive = true
        lowerText.widthAnchor.constraint(equalToConstant: 0.8 * frame.width).isActive = true
        lowerText.topAnchor.constraint(equalTo: bottomAnchor, constant: -0.2 * frame.height).isActive = true
        lowerText.heightAnchor.constraint(equalToConstant: 0.15 * frame.height).isActive = true
    }
    
}
