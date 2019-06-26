//
//  FirstProfileHeader.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 6/24/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class FirstProfileHeader: UIView {

    @IBOutlet weak var firstTopView: UIView!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    
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
        addSubview(firstTopView)
        firstTopView.frame = self.bounds
        firstTopView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
