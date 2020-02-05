//
//  AddPostViewController.swift
/*
    The screen that is presented when the user has selected the media file from the image controller
    Handles tagging and posting
 */
//  Created by Alsahlani, Yassin K on 2/4/20.
//

import UIKit

class AddPostViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //data
    var width: CGFloat = 0
    var height: CGFloat = 0
    
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
    
    func setup() {
        view.backgroundColor = .white
        width = view.frame.width
        height = view.frame.height
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
        
        view.addSubview(postButton)
        
        //constraints
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.leftAnchor.constraint(equalTo: tagField.rightAnchor, constant: width * 0.08).isActive = true
        postButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.12 * height).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: width * 0.19).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: width * 0.19).isActive = true
    }
    
    func setupImageView() {
        imageView.backgroundColor = .white
        imageView.image = UIImage(named: "f1")
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        //constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 0.787 * height).isActive = true
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

}
