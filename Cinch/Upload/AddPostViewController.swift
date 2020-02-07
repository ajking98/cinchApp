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

class AddPostViewController: UIViewController, UIGestureRecognizerDelegate{
    
    //data
    var width: CGFloat = 0
    var height: CGFloat = 0
    var mediaLink = URL(fileURLWithPath: "")
    var isVideo = false
    
    //Elements
    let tagField = UITextView(frame: CGRect.zero)
    let postButton = UIButton(frame: CGRect.zero)
    let imageView = UIImageView(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNavigationController()
        setupTagField()
        setupPostButton()
        setupImageView()
    }
    
    override func viewDidLayoutSubviews() {
        guard isVideo else { return }
        imageView.loadVideo(mediaLink, size: imageView.frame.size)
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
        
        tabBarController?.tabBar.isHidden = true
    }
    
    
    func setupTagField() {
        tagField.backgroundColor = .lightGray
        tagField.text = "#Tags"
        tagField.font?.withSize(24)
        
        view.addSubview(tagField)
        
        //constraints
        tagField.translatesAutoresizingMaskIntoConstraints = false
        tagField.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.12 * height).isActive = true
        tagField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18).isActive = true
        tagField.heightAnchor.constraint(equalToConstant: height * 0.084).isActive = true
        tagField.widthAnchor.constraint(equalToConstant: width * 0.62).isActive = true
        
        addHashTag()
    }
    
    func setupPostButton() {
        postButton.setTitle("Post", for: .normal)
        postButton.titleLabel!.font = UIFont(name: "Avenir-Black", size: 23)
        postButton.backgroundColor = .customRed
        postButton.layer.cornerRadius = 3
        
        postButton.addTarget(self, action: #selector(handlePostMedia), for: .touchUpInside)
        view.addSubview(postButton)
        
        //constraints
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.leftAnchor.constraint(equalTo: tagField.rightAnchor, constant: width * 0.08).isActive = true
        postButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.12 * height).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: height * 0.084).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: height * 0.084).isActive = true
    }
    
    func setupImageView() {
        do {
            if !isVideo {
                let imageData = try Data(contentsOf: mediaLink)
                imageView.image = UIImage(data: imageData)
                print("this is image")
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
        imageView.heightAnchor.constraint(equalToConstant: 0.77 * height).isActive = true
    }
    
    func addHashTag(){
        let hashTagView = UIImageView(image: UIImage(named: "HashTag"))
        hashTagView.frame.size = CGSize(width: 30, height: 30)
        tagField.setContentOffset(CGPoint(x: 50, y: 0), animated: true)
        tagField.addSubview(hashTagView)
        
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handlePostMedia() {
        print("we are posting")

        //TODO: make this an extension to UIViewController
        let actionController = SpotifyActionController()
        actionController.headerData = SpotifyHeaderData(title: "select a folder for the image", subtitle: "", image: UIImage())
        
        UserStruct().readFolders(user: "121212") { (folders) in
            for item in folders {
                print("reaching here")
                actionController.addAction(Action(ActionData(title: "\(item.lowercased())", subtitle: "For Content"), style: .default, handler: { action in
                print("SOmething elese")
                
//                StorageStruct().uploadImage(image: UIImage(), completion: { (link) in
//
//                    FolderStruct().addContent(user: self.username, folderName: item, link: link)
//                    FolderStruct().updateNumOfImagesByConstant(user: self.username, folderName: item, constant: 1)
//                })
                
            }))
        }
        }
        present(actionController, animated: true, completion: nil)
    }

}
