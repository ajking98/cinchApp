//
//  UploadController.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 2/4/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import Photos

class UploadViewController: UIViewController {

    //views
    let uploadButton = UIButton(frame: CGRect.zero)
    let lowerText = UILabel(frame: CGRect.zero)

    //controllers
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationController()
        setupUploadButton()
        setupText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
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
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        imagePicker.sourceType = .photoLibrary
        
        //checks for permission 
        var status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (requestedStatus) in
                status = requestedStatus
                DispatchQueue.main.async {
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }
        }
        if status == .authorized {
            present(imagePicker, animated: true, completion: nil)
        }
    }

}


extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else { return }
        var mediaLink = URL(fileURLWithPath: "")
        
        if mediaType == "public.image" {
            mediaLink = (info[UIImagePickerController.InfoKey.imageURL] as? URL)!
        }
        else if mediaType == "public.movie" {
            mediaLink = (info[UIImagePickerController.InfoKey.mediaURL] as? URL)!
        }
        let vc = AddPostViewController()
        vc.mediaLink = mediaLink
        vc.modalTransitionStyle = .partialCurl
        navigationController?.pushViewController(vc, animated: false)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
