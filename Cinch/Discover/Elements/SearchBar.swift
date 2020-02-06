//
//  SearchBar.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 1/26/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class SearchBar: UISearchBar {
    ///width of screen
    var width: CGFloat = 0
    
    func setup(_ width: CGFloat) {
        self.width = width
        placeholder = "Search"
        backgroundColor = .lightGray
        
        layer.cornerRadius = 3
        frame.size.width = width
        backgroundColor = .white
    }

}
