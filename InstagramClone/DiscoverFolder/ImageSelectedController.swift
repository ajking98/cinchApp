//
//  ImageSelectedController.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 7/5/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class ImageSelectedController: UIViewController {
    var imageName : UIImage!
    var name : String!
    @IBOutlet weak var selectedImage: UIImageView?
    @IBOutlet weak var selectedLikeButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var buttonClicked = true

    override func viewDidLoad() {
        super.viewDidLoad()
        print(name)
        selectedImage?.image = imageName
//
//        guard let name = imageName else { return }
//
//        selectedImage.image = imageName
//
        selectedImage?.isUserInteractionEnabled = true
        selectedImage?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePressed)))
    }
    
    @IBAction func shareAction(_ sender: Any) {
        print("Share")
    }
    @IBAction func selectedLikeAction(_ sender: Any) {
        if buttonClicked {
            print("Liked")
            UIView.animate( withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.selectedLikeButton.setImage(UIImage.init(named: "icons8-heart-pressed"), for: UIControl.State.normal)
                self.selectedLikeButton.transform = CGAffineTransform(scaleX: 2, y: 2)
                Helper().vibrate(style: .heavy)
                self.buttonClicked = false
            })
            UIView.animate( withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.selectedLikeButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        } else {
            UIView.animate( withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.selectedLikeButton.setImage(UIImage.init(named: "icons8-heart-unpressed"), for: UIControl.State.normal)
                self.selectedLikeButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                Helper().vibrate(style: .light)
                self.buttonClicked = true
            })
        }
    }
    
    
    func setupView(image : UIImage){
        print(name)
        print(image)
        print(selectedImage?.image)
        selectedImage?.image = image
    }
//
//    func setupView(image : String) {
//        selectedImage.image = UIImage(named: image)
//    }
//
//
    @objc func handlePressed(_ tapGesture : UITapGestureRecognizer) {
        print("this is working")
        dismiss(animated: true, completion: nil)
    }
//
    
}
