//
//  TableSearchViewController.swift
//  Cinch
//
//  Created by Ahmed Gedi on 11/4/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit

class TableSearchViewController : UITableViewController {
    
    var listOfTags:[String] = []
    var updatedListOfTags:[String] = []
    let reusibleIdentifier = "Cell"
    var previousSearchTerm = ""
    var pendingFunction : ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reusibleIdentifier)
        fetchAllTags()
    }
    
    //todo make this search algo O(NLog(N))
    /*
     Insert kick ass algorithm here!
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pendingFunction!(updatedListOfTags[indexPath.row])
    }
    
    func updateTagList(searchTerm : String) {
        //update list of tags
        if previousSearchTerm == searchTerm.dropLast() {
            updatedListOfTags.removeAll()
            for term in listOfTags {
                if term.contains(searchTerm) {
                    updatedListOfTags.append(term)
                }
                tableView.reloadData()
            }
        }
        else {
            var index = 0
            while index < updatedListOfTags.count {
                if !updatedListOfTags[index].contains(searchTerm) {
                    let indexPath = IndexPath(row: index, section: 0)
                    updatedListOfTags.remove(at: index)
                    tableView.deleteRows(at: [indexPath], with: .bottom)
                }else {
                    index += 1
                }
            }
        }
        previousSearchTerm = searchTerm
    }
    
    
    func fetchAllTags() {
        ParentTagStruct().readTagNames(completion: { (tags) in
            self.listOfTags = tags
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updatedListOfTags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusibleIdentifier, for: indexPath)
        cell.textLabel?.text = updatedListOfTags[indexPath.row]
        return cell
    }
}
