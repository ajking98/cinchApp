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
        expandView()
        tableTagsView.alpha = 1
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if presentationStyle == .compact {
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
            searchTableViewController.addSearchTerm(term: searchBar.text!)
            
            //TODO: Move this to a function
            searchBar.endEditing(true)
            let vc = MessageSearchResultsViewController()
            vc.initialNavigationController = navigationController
            vc.setup(term: searchBar.text!)
            vc.minimizeView = minimizeView
            navigationController?.pushViewController(vc, animated: true)

//            nextView(text: searchBar.text!)
        }
    }
    
    //TODO: This should be in a global function
    func expandView() {
        if presentationStyle == .compact {
            requestPresentationStyle(.expanded)
        }
    }
    
    func minimizeView() {
        if presentationStyle == .expanded {
            requestPresentationStyle(.compact)
        }
    }
}


