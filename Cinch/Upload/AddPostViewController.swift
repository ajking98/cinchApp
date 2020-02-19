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

class AddPostViewController: UIViewController, UIGestureRecognizerDelegate{
    //data
    var width: CGFloat = 0
    var height: CGFloat = 0
    var mediaLink = URL(fileURLWithPath: "")
    var isVideo = false
    
    //Elements
    let tagField = UITextView(frame: CGRect.zero)
    let imageView = UIImageView(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNavigationController()
        setupTagField()
        setupImageView()
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
        tagField.backgroundColor = .lightGray
        tagField.text = "#Tags"
        tagField.font = UIFont(name: "Avenir-Heavy", size: 23)
        tagField.layer.cornerRadius = 6
        
        view.addSubview(tagField)
        
        //constraints
        tagField.translatesAutoresizingMaskIntoConstraints = false
        tagField.topAnchor.constraint(equalTo: view.topAnchor, constant: (navigationController?.navigationBar.frame.height)!).isActive = true //TODO: Fix this 
        tagField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tagField.heightAnchor.constraint(equalToConstant: height * 0.084).isActive = true
        tagField.widthAnchor.constraint(equalToConstant: width * 0.9).isActive = true
        
        addHashTag()
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
        view.addSubview(imageView)
        
        //constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 0.7 * height).isActive = true
    }
    
    func addHashTag(){
        let hashTagView = UIImageView(image: UIImage(named: "HashTag"))
        hashTagView.frame.size = CGSize(width: 30, height: 30)
        tagField.setContentOffset(CGPoint(x: 50, y: 0), animated: true)
//        tagField.addSubview(hashTagView)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tagField.endEditing(true)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handlePostMedia() {
        SaveToFolder().saveToFolder(navigationController!, localLink: mediaLink, tags: tagField.text)
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
        let message = tags.components(separatedBy: CharacterSet(charactersIn: " ./"))
        var tagArray = [String]()
        guard let username = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey) else { return }
        
        for tag in message{
            if tag.count > 2 {
                let standardizedTag = tag.lowercased()
                tagArray.append(standardizedTag)
                TagStruct().addElement(tagLabel: standardizedTag, tagElement: TagElement(link: link))
            }
        }
        let post = Post(isImage: !checkIfVideo(link), postOwner: username, link: link)
        post.tags = tagArray
        ParentPostStruct().addPost(post: post)
    }
    
}
