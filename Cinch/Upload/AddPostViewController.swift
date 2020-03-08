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
    var frames:[UIImage] = []
    
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
    
    ///fetches the thumbnail frames for a video
    func fetchFrames(url: URL) {
        getAllFrames(videoUrl: url, completion: {(images) in
            print("this is the count of the images: ", images.count)
            self.frames = images
        })
    }
    
    
    func setup() {
        view.backgroundColor = .white
        width = view.frame.width
        height = view.frame.height
        isVideo = checkIfVideo(mediaLink.absoluteString)
        
        if isVideo {
            fetchFrames(url: mediaLink)
        }
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
        SaveToFolder().saveToFolder(navigationController!, localLink: mediaLink, tags: tagField.text, frames)
    }
}





struct SaveToFolder {
    func saveToFolder(_ navigationController: UINavigationController, localLink: URL, tags: String, _ frames: [UIImage]? = nil) {
        let image = UIImage()
        let actionController = SpotifyActionController()
        actionController.headerData = SpotifyHeaderData(title: "Select a Folder", subtitle: "", image: image)
        guard let username = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey) else { return }
        
        
        UserStruct().readFolders(user: username) { (folders) in
            for item in folders {
                if item.lowercased() == "hearted" {
                    continue
                }
                actionController.addAction(Action(ActionData(title: "\(item.lowercased())", subtitle: "For Content"), style: .default, handler: { action in
                    
                    StorageStruct().uploadContent(mediaLink: localLink) { (link) in
                        FolderStruct().addContent(user: username, folderName: item, link: link)
                        self.addTags(link: link, tags: tags, frames)
                        navigationController.popViewController(animated: true)
                        
                        //user feedback alert
                        let alert = UIAlertController(title: "Uploaded to \(item)!", message: "", preferredStyle: .alert)
                        navigationController.present(alert, animated: true, completion: nil)
                        let alertExpiration = DispatchTime.now() + 2
                        DispatchQueue.main.asyncAfter(deadline: alertExpiration) {
                            alert.dismiss(animated: true, completion: nil)
                        }
                                                
                        //Adds content to the followers' newContent array this should be done on a google cloud function
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
    
    
    func addTags(link: String, tags: String, _ frames: [UIImage]? = nil){
        let message = tags.components(separatedBy: CharacterSet(charactersIn: " ./\\#"))
        var tagArray = [String]()
        guard let username = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey) else { return }
        
        var post: Post?
        if checkIfVideo(link) {
        ///Adding the frames if its a video
            if let frames = frames {
                print("step 2")
                StorageStruct().uploadFrames(frames: frames) { (links) in
                    post = Post(isImage: false, postOwner: username, link: link, links)
                    guard let standardPost = post else { return }
                    standardPost.tags = tagArray
                    ParentPostStruct().addPost(post: standardPost)
                }
            }
        }
        else { //If image
            post = Post(isImage: true, postOwner: username, link: link)
            guard let standardPost = post else { return }
            standardPost.tags = tagArray
            ParentPostStruct().addPost(post: standardPost)
            print("this has been completed")
        }
        
        for tag in message{
            if tag.count > 2 {
                let standardizedTag = tag.lowercased()
                tagArray.append(standardizedTag)
                TagStruct().addElement(tagLabel: standardizedTag, tagElement: TagElement(link: link, contentKey: post!.contentKey))
            }
        }
        
    }
    
}
