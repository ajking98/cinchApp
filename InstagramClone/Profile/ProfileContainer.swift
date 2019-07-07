//
//  ProfileContainer.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 6/30/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit

class ProfileContainer: UIViewController {
    @IBOutlet weak var rightMenuSideConstraint: NSLayoutConstraint!
    var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(toggleSideMenu),
                                               name: NSNotification.Name(rawValue: "Toggle Side Menu"),
                                               object: nil)
    }
    @objc func toggleSideMenu() {
        if isExpanded {
            isExpanded = false
            rightMenuSideConstraint.constant = 300
        } else {
            isExpanded = true
            rightMenuSideConstraint.constant = 0
        }
    }
}
