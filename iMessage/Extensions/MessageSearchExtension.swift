//
//  MessageSearchExtension.swift
//  iMessage
//
//  Created by Alsahlani, Yassin K on 2/7/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit


//Search
extension MessagesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        print("this is the activity for search bar: ", iMessageDelegate)
        iMessageDelegate.expandView()
        tableTagsView.alpha = 1
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if iMessageDelegate.getPresentationStyle() == .compact {
            return false
        }
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        tableTagsView.alpha = 0
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            if searchBar.text != nil {
                guard let text = searchBar.text else { return }
                nextView(term: text)
            }
        }
    }
    
}


