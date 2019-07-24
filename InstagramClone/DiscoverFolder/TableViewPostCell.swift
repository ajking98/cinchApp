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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func optionMenu(_ sender: Any) {
        
    }
    @IBAction func shareAction(_ sender: Any) {
        
    }
    @IBAction func likeAction(_ sender: Any) {
        
    }

}
