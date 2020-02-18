//
//  SearchTableViewController.swift
/*
    This view appears when the user is searching a term
    This view provides the user with suggested terms to search 
 */
//  Created by Alsahlani, Yassin K on 2/6/20.

import Foundation
import UIKit



class SearchTableViewController: UITableViewController {
    let identifier = "Cell"
    var searchHistory = ["Meme", "Funny"]
    var handleCellSelected: ((String) -> Void)!
    var secondTableView = UITableView()
    var searchView = UISearchBar()

    
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
        guard let text = tableView.cellForRow(at: indexPath)?.textLabel?.text else { return }
        handleCellSelected(text)
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
    
    ///Adds a search term to the searchview suggested search terms 
    func addSearchTerm(term: String) {
        guard !searchHistory.contains(term) else { return } //doesn't add the term if it already exists
        if searchHistory.count == 7 {
            searchHistory.remove(at: 6)
        }
        searchHistory.insert(term, at: 0)
        
        secondTableView.reloadData()
    }
}
