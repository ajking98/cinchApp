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
    var prevSearchText = ""
    var allTags:[String] = []
    var tags:[String] = []
    var handleCellSelected: ((String) -> Void)!
    var secondTableView = UITableView()

    
    func setup() {
        fetchData(true)
    }
    
    func fetchData(_ shouldReset: Bool = false){
        ParentTagStruct().readTagNames { (tags) in
            self.allTags = tags
            if shouldReset {
                self.resetTags()
            }
        }
    }
    
    func resetTags(_ searchTerm : String? = nil) {
        tags = allTags
        if let searchTerm = searchTerm {
            handleSearching(searchText: searchTerm)
        }
        else {
            self.secondTableView.reloadData()
        }
    }
    
    
    func handleSearching(searchText: String) {
        tags.removeAll { (term) -> Bool in
            return !term.contains(searchText)
        }
        secondTableView.reloadData()
        if prevSearchText.count > searchText.count {
            prevSearchText = searchText
            if searchText.count == 0 {
                resetTags()
            }
            else {
                resetTags(searchText)
            }
        }
        prevSearchText = searchText
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        secondTableView = tableView
        return tags.count < 6 ? tags.count : 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        cell.textLabel?.text = tags[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let text = tableView.cellForRow(at: indexPath)?.textLabel?.text else { return }
        handleCellSelected(text)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard tableView.numberOfRows(inSection: 0) == 0 else { return UIView() } //tableview is empty, then it will say "no results found"
        let clearSearch = UILabel(frame: CGRect(x: 0, y: 10, width: tableView.frame.width, height: 30))
        clearSearch.center.x = tableView.center.x
        clearSearch.textColor = .gray
        clearSearch.textAlignment = .center
        clearSearch.text = "No Results Found"
        return clearSearch
    }
}
