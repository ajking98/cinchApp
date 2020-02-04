//
//  UploadController.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 2/4/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController {

    //elements
    let uploadButton = UIButton(frame: CGRect.zero)
    let lowerText = UILabel(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationController()
        setupUploadButton()
        setupText()
    }
    
    func setupNavigationController() {
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.layoutIfNeeded()
    }
    
    func setupUploadButton() {
        let buttonWidth = 0.46 * view.frame.width
        uploadButton.setImage(UIImage(named: "uploadButton"), for: .normal)
        uploadButton.frame.size = CGSize(width: buttonWidth, height: buttonWidth)
        
        uploadButton.center = view.center
        view.addSubview(uploadButton)
        
        uploadButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectMedia)))
    }
    
    func setupText() {
        lowerText.textAlignment = .center
        lowerText.text = "Upload From iPhone"
        lowerText.font = UIFont(name: "Avenir-Heavy", size: 23)
        lowerText.textColor = .darkerGreen
        lowerText.isUserInteractionEnabled = true
        lowerText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectMedia)))
        
        
        view.addSubview(lowerText)
        //constraints
        lowerText.translatesAutoresizingMaskIntoConstraints = false
        lowerText.topAnchor.constraint(equalTo: uploadButton.bottomAnchor, constant: 25).isActive = true
        lowerText.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lowerText.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lowerText.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    
    @objc func selectMedia() {
        print("we are picking")
        let vc = AddPostViewController()
//        vc.modalPresentationStyle = .currentContext
        vc.modalTransitionStyle = .partialCurl
//        present(vc, animated: true, completion: nil)
//        navigationController?.pushViewController(vc, animated: true)
        navigationController?.show(vc, sender: nil)
    }

}
