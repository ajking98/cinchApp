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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        iMessageDelegate.expandView()
        guard let textCount = searchBar.text?.count else {
            return
        }

        if textCount == 0 {
            searchTableViewController.setup()
            searchPriorityViewController.tags = mainHashTags
            priorityTagsView.reloadData()
            tableTagsView.alpha = 0
            priorityTagsView.alpha = 1
        }
        else {
            tableTagsView.alpha = 1
        }
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
        priorityTagsView.alpha = 0
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            guard let text = searchBar.text else { return }
            nextView(term: text)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTableViewController.handleSearching(searchText: searchText.lowercased())
        
        if searchText.count == 0 {
            tableTagsView.alpha = 0
            priorityTagsView.alpha = 1
        }
        else {
            priorityTagsView.alpha = 0
            tableTagsView.alpha = 1
        }
    }
    
    
    ///presents the next vc when the user enters a term to search
    func nextView(term: String) {
        tableTagsView.alpha = 0
        searchBar.endEditing(true)
        let vc = MessageSearchResultsViewController()
        vc.initialNavigationController = navigationController
        vc.setup(term: term)
        vc.iMessageDelegate = iMessageDelegate
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    ///Builds the UI for the priority tags
    func setupPriorityTagsView() {
        fetchPriorityTags()
        view.addSubview(priorityTagsView)
        priorityTagsView.alpha = 0
        priorityTagsView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        searchPriorityViewController.handleCellSelected = nextView(term:)
        priorityTagsView.dataSource = searchPriorityViewController
        priorityTagsView.delegate = searchPriorityViewController
        priorityTagsView.separatorStyle = .none

        priorityTagsView.translatesAutoresizingMaskIntoConstraints = false
        priorityTagsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        priorityTagsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        priorityTagsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        priorityTagsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    ///Builds UI for tag suggestions
    func setupTableTagsView() {
        view.addSubview(tableTagsView)
        tableTagsView.alpha = 0
        tableTagsView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        tableTagsView.dataSource = searchTableViewController
        tableTagsView.delegate = searchTableViewController
        searchTableViewController.handleCellSelected = nextView(term:)
        searchTableViewController.setup()
        tableTagsView.separatorStyle = .none
        
        //constraints
        tableTagsView.translatesAutoresizingMaskIntoConstraints = false
        tableTagsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableTagsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableTagsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableTagsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    func fetchPriorityTags() {
        ParentTagStruct().readAdminTags { (tags) in
            tags.forEach { (hashTagTerm) in
                self.mainHashTags.append(hashTagTerm.lowercased().capitalizeFirstLetter())
            }
        }
    }
}


