//
//  SearchBar.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 1/26/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class SearchBar: UITextField {
    ///width of screen
    var width: CGFloat = 0
    
    func setup(_ width: CGFloat) {
        self.width = width
        placeholder = "Search"
        backgroundColor = .lightGray
        
        layer.cornerRadius = 3
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 0.1 * width, height: frame.height))
        let searchIcon = UIImageView(frame: CGRect(x: 11, y: 0, width: 14, height: 14.43))
        searchIcon.center.y = center.y
        searchIcon.image = UIImage(named: "searchIcon")
        
        paddingView.addSubview(searchIcon)
        leftView = paddingView
        leftViewMode = UITextField.ViewMode.always
    }

}
