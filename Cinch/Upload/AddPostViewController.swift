//
//  AddPostViewController.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 2/4/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class AddPostViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //Elements
    let tagField = UITextView(frame: CGRect.zero)
    let postButton = UIButton(frame: CGRect.zero)
    let imageView = UIImageView(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNavigationController()
        setupTagField()
    }
    
    func setup() {
        view.backgroundColor = .white
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
        tagField.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.12 * view.frame.height).isActive = true
        tagField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18).isActive = true
        tagField.heightAnchor.constraint(equalToConstant: view.frame.height * 0.084).isActive = true
        tagField.widthAnchor.constraint(equalToConstant: view.frame.width * 0.62).isActive = true
        
        addHashTag()
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
