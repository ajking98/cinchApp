//
//  AddPostViewController.swift
/*
    The screen that is presented when the user has selected the media file from the image controller
    Handles tagging and posting
 */
//  Created by Alsahlani, Yassin K on 2/4/20.
//

import UIKit
import XLActionController
import AVKit

class AddPostViewController: UIViewController, UIGestureRecognizerDelegate, UITextViewDelegate{
    //data
    var width: CGFloat = 0
    var height: CGFloat = 0
    var mediaLink = URL(fileURLWithPath: "")
    var isVideo = false
    
    //Elements
    let tagField = UITextView(frame: CGRect.zero)
    let placeholderLabel = UILabel()
    let imageView = UIImageView(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNavigationController()
        setupImageView()
        setupTagField()
    }
    
    override func viewDidLayoutSubviews() {
        guard isVideo else { return }
        let playerLayer = imageView.loadVideo(mediaLink, size: imageView.frame.size)
    }
    
    
    func setup() {
        view.backgroundColor = .white
        width = view.frame.width
        height = view.frame.height
        isVideo = checkIfVideo(mediaLink.absoluteString)
    }
    
    func setupNavigationController() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true 
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backIcon-black"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        let leftNavBarItem = UIBarButtonItem(customView: backButton)
        navigationItem.setLeftBarButton(leftNavBarItem, animated: false)
        
        //Post button item
        let postButton = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(handlePostMedia))
        navigationItem.setRightBarButton(postButton, animated: false)
    }
    
    
    func setupTagField() {
        tagField.backgroundColor = .lightishGray
        tagField.delegate = self
        tagField.font = UIFont(name: "Avenir-Medium", size: 18)
        tagField.layer.cornerRadius = 2
        
        view.addSubview(tagField)
        
        //constraints
        tagField.translatesAutoresizingMaskIntoConstraints = false
        tagField.topAnchor.constraint(equalTo: view.topAnchor, constant: height * 0.1).isActive = true
        tagField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tagField.heightAnchor.constraint(equalToConstant: height * 0.084).isActive = true
        tagField.widthAnchor.constraint(equalToConstant: width * 0.9).isActive = true
        
        
        addPlaceHolder()
    }
    
    
    func setupImageView() {
        do {
            if !isVideo {
                let imageData = try Data(contentsOf: mediaLink)
                imageView.image = UIImage(data: imageData)
            }
        }
        catch {
            print("error")
        }
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        //constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 0.7 * height).isActive = true
    }
    
    func addPlaceHolder(){
        placeholderLabel.text = "#meme  #LOL  #..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (tagField.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        tagField.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (tagField.font?.pointSize)! / 2)
        placeholderLabel.textColor = .gray
        placeholderLabel.isHidden = !tagField.text.isEmpty
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tagField.endEditing(true)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func handlePostMedia() {
        SaveToFolder().saveToFolder(navigationController!, localLink: mediaLink, tags: tagField.text)
        let alert = UIAlertController(title: "Uploaded!", message: "", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let alertExpiration = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: alertExpiration) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}





struct SaveToFolder {
    func saveToFolder(_ navigationController: UINavigationController, localLink: URL, tags: String) {
        let image = UIImage()
        let actionController = SpotifyActionController()
        actionController.headerData = SpotifyHeaderData(title: "select a folder", subtitle: "", image: image)
        guard let username = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey) else { return }
        
        
        UserStruct().readFolders(user: username) { (folders) in
            for item in folders {
                actionController.addAction(Action(ActionData(title: "\(item.lowercased())", subtitle: "For Content"), style: .default, handler: { action in
                    
                    StorageStruct().uploadContent(mediaLink: localLink) { (link) in
                        FolderStruct().addContent(user: username, folderName: item, link: link)
                        self.addTags(link: link, tags: tags)
                        navigationController.popViewController(animated: true)
                        
                        //Adds content to the followers' newContent array
                        UserStruct().readFollowers(user: username) { (followers) in
                            for follower in followers {
                                UserStruct().addNewContent(user: follower, link: link)
                            }
                        }
                    }
                }))
            }
            navigationController.present(actionController, animated: true, completion: nil)
        }
    }
    
    func addTags(link: String, tags: String){
        let message = tags.components(separatedBy: CharacterSet(charactersIn: " ./\\#"))
        var tagArray = [String]()
        guard let username = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey) else { return }
        
        for tag in message{
            if tag.count > 2 {
                let standardizedTag = tag.lowercased()
                tagArray.append(standardizedTag)
                TagStruct().addElement(tagLabel: standardizedTag, tagElement: TagElement(link: link))
            }
        }
        
        var post: Post?
        if checkIfVideo(link) {  //If video
            do {
                try time {
                    if let sourceURL = URL(string: link) {
                        let asset = AVURLAsset(url: sourceURL)
                        let trimmedAsset = try asset.assetByTrimming(timeOffStart: 1) //Only getting 1 second
                        let playerItem = AVPlayerItem(asset: trimmedAsset)
                        StorageStruct().uploadVideo(video: playerItem) { (thumbnailLink) in
                            post = Post(isImage: false, postOwner: username, link: link)
                            post?.thumbnail = thumbnailLink
                            print("we are uploading the thumbnail")
                            guard let standardPost = post else { return }
                            standardPost.tags = tagArray
                            ParentPostStruct().addPost(post: standardPost)
                        }
                    }
                }
            } catch let error {
                print("💩 \(error)")
            }
        }
        else { //If image
            post = Post(isImage: true, postOwner: username, link: link)
            guard let standardPost = post else { return }
            standardPost.tags = tagArray
            ParentPostStruct().addPost(post: standardPost)
        }
        
    }
    
}
