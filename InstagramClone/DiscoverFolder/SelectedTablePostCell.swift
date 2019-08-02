//
//  SelectedTablePostCell.swift
//  InstagramClone
//
//  Created by Gedi, Ahmed M on 8/2/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class SelectedTablePostCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    var buttonClicked = true
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func shareAction(_ sender: Any) {
        print("Share")
    }
    
    @IBAction func likeAction(_ sender: Any) {
        if buttonClicked {
            print("Liked")
            UIView.animate( withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.likeButton.setImage(UIImage.init(named: "icons8-heart-pressed"), for: UIControl.State.normal)
                self.likeButton.transform = CGAffineTransform(scaleX: 2, y: 2)
                Helper().vibrate(style: .heavy)
                self.buttonClicked = false
            })
            UIView.animate( withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.likeButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        } else {
            print("Unliked")
            UIView.animate( withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.likeButton.setImage(UIImage.init(named: "icons8-heart-unpressed"), for: UIControl.State.normal)
                self.likeButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                Helper().vibrate(style: .light)
                self.buttonClicked = true
            })
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
