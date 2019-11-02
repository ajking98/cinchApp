//
//  FirstProfileHeader.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 6/24/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import SDWebImage

class FirstProfileHeader: UIView {

    @IBOutlet weak var firstTopView: UIView!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    var username : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstTopView.backgroundColor = .red
    }
//    func xibSetup() {
//        firstTopView.backgroundColor = .red
//    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("FirstProfileHeader", owner: self, options: nil)
        
        if username == nil {
            username = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)
            messageButton.isHidden = true
            followButton.isHidden = true
        }
        
        addSubview(firstTopView)
        firstTopView.frame = self.bounds
        firstTopView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        
        //sets profile picture
        UserStruct().readProfilePic(user: username) { (link) in
            let url = URL(string: link)
            self.userProfileImage.sd_setImage(with: url, placeholderImage: UIImage(named: "n2"), completed: nil)
        }
//        self.userProfileImage.frame.size = CGSize(width: 80, height: 80)
        self.userProfileImage.contentMode = .scaleAspectFill
        self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.height / 2
        
        
        //sets the full name
        UserStruct().readName(user: username) { (name) in
            self.fullName.text = name
        }
        
        //sets the username
        userName.text = username
        
    }

}
