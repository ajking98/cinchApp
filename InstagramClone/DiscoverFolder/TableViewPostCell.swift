//
//  TableViewPostCell.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 7/23/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class TableViewPostCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var menuOption: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    var buttonClicked = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postImage.layer
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func optionMenu(_ sender: Any) {
        print("More Options")
    }
    @IBAction func shareAction(_ sender: Any) {
        print("Share")
    }
    @IBAction func likeAction(_ sender: Any) {
        if buttonClicked {
            print("Liked")
            UIView.animate( withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                    self.likeButton.setImage(UIImage.init(named: "icons8-heart-pressed"), for: UIControl.State.normal)
                    self.likeButton.transform = CGAffineTransform(scaleX: 2, y: 2)
                    Helper().vibrate(style: .heavy)
                    self.buttonClicked = false
            })
            UIView.animate( withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.likeButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        } else {
            UIView.animate( withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.likeButton.setImage(UIImage.init(named: "icons8-heart-unpressed"), for: UIControl.State.normal)
                self.likeButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                Helper().vibrate(style: .light)
                self.buttonClicked = true
            })
        }
    }

}
