//
//  SearchTableViewController.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 2/6/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit



class SearchTableViewController: UITableViewController {
    let identifier = "Cell"
    var searchHistory = ["Food", "Oranges", "Onions", "iPhone", "Swimming"]
    var secondTableView = UITableView()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        secondTableView = tableView
        return searchHistory.count //todo this should be dynamic
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        cell.textLabel?.text = searchHistory[indexPath.row]
//        cell.imageView?.image = UIImage(named: "recentIcon")
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("this row has been selected : ", indexPath.row)
        presentNextView(term: searchHistory[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let clearSearch = UILabel(frame: CGRect(x: 0, y: 10, width: tableView.frame.width, height: 30))
        clearSearch.center.x = tableView.center.x
        clearSearch.textColor = .gray
        clearSearch.textAlignment = .center
        clearSearch.text = "Clear Search History"
        clearSearch.isUserInteractionEnabled = true
        clearSearch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleClearSearch)))
        return clearSearch
    }
    
    @objc func handleClearSearch() {
        searchHistory = []
        secondTableView.reloadData()
    }
    
    func addSearchTerm(term: String) {
        if searchHistory.count == 10 {
            searchHistory.remove(at: 9)
        }
        searchHistory.insert(term, at: 0)
        
        secondTableView.reloadData()
    }
    
    
    func presentNextView(term: String) {
        print("present the next view")
    }
}