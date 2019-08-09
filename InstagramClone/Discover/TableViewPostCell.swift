//
//  TableViewPostCell.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 7/23/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class TableViewPostCell: UITableViewCell {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var postImage: UIImageView!
    
    var likeButton = LikeButton()
    var shareButton = ShareButton()
    var menuOptions = MenuOptions()
    
    var buttonClicked = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postImage.layer
        
        setUp()
    }
    
    func setUp() {
        let centerX = sideView.frame.width / 2
        let bottomY = sideView.frame.height
        
        //Menu
        menuOptions.center = CGPoint(x: centerX, y: 30)
        
        
        //share
        shareButton.center = CGPoint(x: centerX, y: bottomY - 65)
        
        
        //like View
        likeButton.center = CGPoint(x: centerX, y: bottomY - 30)
        
        
        //adding subviews
        sideView.addSubview(menuOptions)
        sideView.addSubview(shareButton)
        sideView.addSubview(likeButton)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
