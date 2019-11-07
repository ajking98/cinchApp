//
//  SelectedTablePostCell.swift
//  Cinch
//
//  Created by Gedi, Ahmed M on 8/2/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class SelectedTablePostCell: UITableViewCell {

    @IBOutlet weak var labels: UIView!
    @IBOutlet weak var postImage: UIImageView!
    
    
    var buttonClicked = true
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
