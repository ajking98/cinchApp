//
//  PermissionsController.swift
//  InstagramClone
//
//  Created by Alsahlani, Yassin K on 6/19/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class PermissionsController: UIViewController {
    @IBOutlet weak var outerMost: UIView!
    @IBOutlet weak var middle: UIView!
    @IBOutlet weak var innerMost: UIView!
    @IBOutlet weak var gotItButton: UIButton!
    @IBOutlet weak var cancelLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildCircles()
        buildBorder()
        underline()
    }
    
    
    func buildCircles(){
        outerMost.layer.cornerRadius = outerMost.frame.width/2
        middle.layer.cornerRadius = middle.frame.width / 2
        innerMost.layer.cornerRadius = innerMost.frame.width/2
        gotItButton.layer.cornerRadius = gotItButton.frame.height/2
    }
    
    func buildBorder(){
        innerMost.layer.borderWidth = 3
        innerMost.layer.borderColor = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF, alpha: 1).cgColor
        
        gotItButton.layer.borderWidth = 1
        gotItButton.layer.borderColor = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF, alpha: 1).cgColor
    }
    
    func underline() {
        let spacing = 0.5
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = cancelLabel.textColor
        cancelLabel.addSubview(line)
        cancelLabel.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[line]|", metrics: nil, views: ["line":line]))
        cancelLabel.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(1)]-(\(-spacing))-|", metrics: nil, views: ["line":line]))
    }


}
