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
        print("this shit loaded son")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
        
        navigationItem.title = "Upload From iPhone"
    }
    
    func setupUploadButton() {
        uploadButton.setTitle("+ Add Meme", for: .normal)
        uploadButton.backgroundColor = .systemBlue
        uploadButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        view.addSubview(uploadButton)
        uploadButton.layer.cornerRadius = 5
        
        //constraints
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            uploadButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            uploadButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            uploadButton.heightAnchor.constraint(equalToConstant: 56),
            uploadButton.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.6),
        ])
        
        uploadButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectMedia)))
    }
    
    @objc func selectMedia() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen

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
        
        //Uncomment this for the upload script
//        let uploadScriptVC = UploadScriptVC()
//        uploadScriptVC.modalPresentationStyle = .fullScreen
//        self.present(uploadScriptVC, animated: true, completion: nil)
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
            let length = AVURLAsset(url: mediaLink).duration.seconds
            guard length < 90 else {
                self.dismiss(animated: true) {
                    let alert = UIAlertController(title: "Upload failed", message: "Video cannot be longer than 90 seconds", preferredStyle: .alert)
                    self.present(alert, animated: true) {
                        alert.view.superview?.isUserInteractionEnabled = true
                        alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAert)))
                    }
                    let alertExpiration = DispatchTime.now() + 5
                    DispatchQueue.main.asyncAfter(deadline: alertExpiration) {
                        alert.dismiss(animated: true, completion: nil)
                    }
                }
                return
            }
        }
        let vc = AddPostViewController()
        vc.mediaLink = mediaLink
        vc.modalTransitionStyle = .partialCurl
        navigationController?.pushViewController(vc, animated: false)
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func dismissAert() {
        print("this is dismissing")
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
