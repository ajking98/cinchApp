//
//  ImageSelectedController.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 7/5/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class ImageSelectedController: UIViewController {
    
    @IBOutlet weak var selectedImage: UIImageView!
    var imageName : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let name = imageName else { return }
        
        selectedImage.image = imageName
        
        selectedImage.isUserInteractionEnabled = true
        selectedImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePressed)))
    }
    
    
    func setupView(image : UIImage){
        selectedImage.image = image
    }
    
    func setupView(image : String) {
        selectedImage.image = UIImage(named: image)
    }
    
    
    @objc func handlePressed(_ tapGesture : UITapGestureRecognizer) {
        print("this is working")
        dismiss(animated: true, completion: nil)
    }
    
    
}
