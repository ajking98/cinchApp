//
//  MainDiscover.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 8/9/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit


//TODO move this to the parent DiscoverController
class TableSearchViewController : UITableViewController {
    
    var listOfTags:[String] = []
    var updatedListOfTags:[String] = []
    let reusibleIdentifier = "Cell"
    var previousSearchTerm = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reusibleIdentifier)
        fetchAllTags()
    }
    
    //todo make this search algo O(NLog(N))
    /*
        Insert kick ass algorithm here!
    */
    func updateTagList(searchTerm : String) {
        //update list of tags
        print("updating my tuff", previousSearchTerm, "and ", searchTerm.dropLast(), previousSearchTerm == searchTerm.dropLast())
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
            print("truing")
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

var searchView : TableSearchViewController?

class PrimaryDiscoverController: DiscoverController, SearchDelegate {
    
    func search(searchTerm: String) {
        guard let searchView = searchView else { return }
        
        guard searchTerm.count > 1 else {
            UIView.animate(withDuration: 0.2) {
                searchView.view.layer.opacity = 0
            }
            return
        }
        searchView.updateTagList(searchTerm: searchTerm)
        print("we are searching this: ", searchTerm)
        UIView.animate(withDuration: 0.2) {
            searchView.view.layer.opacity = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSearchBar()
        buildSearchView()
    }
    
    func addSearchBar() {
        let frame = collectionView.frame
        
        //sizing
        searchBar = SearchBar(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: frame.width * 0.88, height: 33)))
        searchBar?.searchDelegate = self
        guard let searchBar = searchBar else {
            return
        }
        
        //positioning
        searchBar.center.y = segmentControl.frame.origin.y + 80
        searchBar.center.x = view.center.x
        
        let tapped = UITapGestureRecognizer(target: searchBar, action: #selector(searchBar.revertToNormal))
        tapped.cancelsTouchesInView = false
        view.addGestureRecognizer(tapped)
        searchBar.backgroundColor = .white
        view.addSubview(searchBar)
    }
    
    
    //builds the table view for the search (to hold the suggested tag)
    func buildSearchView() {
        let width = view.frame.width
        let height = view.frame.height
        
        searchView = TableSearchViewController(style: .plain)
        guard let searchView = searchView else { return }
        
        searchView.view.layer.opacity = 0
        searchView.view.frame = CGRect(x: 0, y: 0, width: width * 0.88, height: height * 0.3)
        searchView.view.center.x = view.center.x
        searchView.view.layer.cornerRadius = 10
        searchView.view.frame.origin.y = collectionView.frame.origin.y - 15
        view.addSubview(searchView.view)
    }

    
    
    
    
    func translateTables(_ translation: CGFloat) {
        collectionView.center.y += translation
        collectionView.frame.size.height -= translation
        
        tableView.center.y += translation
        tableView.frame.size.height -= translation
    }
    
    //when user scrolls in the scrollview, the view should pan and either move the segment control out the view or into the view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let gesture = scrollView.panGestureRecognizer
        
        if (scrollView.contentOffset.y < -80){
            scrollView.contentOffset.y = -80
            gesture.state = .ended
        }
        
        //TODO clean this up
        switch gesture.state {
            
        case .began, .changed:
            let translation = gesture.translation(in: scrollView.superview).y * 0.1
            
            
            //if the segment control is less than or equal to the normalized center, then continue
            guard (segmentControl.center.y + translation) <= segmentControlCenter!.y else {
                return
            }
            
            //if pan is in the negative direction and the segment control hasn't reached its peak height
            if (translation < 0 && segmentControl.center.y > (-10 - segmentControl.frame.height)){
                segmentControl.center.y += translation
                buttonBar.center.y += translation
                searchBar!.center.y += translation
            }
            
            //if the summation of the translation and scrollview y-axis is within bounds
            // bounds are: 100 < origin.y < scrollViewFrame.y
            if(100 < scrollView.frame.origin.y + translation && scrollView.frame.origin.y + translation <= (scrollViewFrame?.origin.y)!){
                guard scrollView.frame.origin.y > 102 else {
                    return
                }
                
                if translation < 0 {
                    translateTables(translation)
                }
            }
        case .ended:
            print("refreshing", scrollView.contentOffset)
            //refresh the scrollviews
            if scrollView.contentOffset.y <= -50 && !isRefreshing {
                print("reached refreshing")
                
                //vibrate for feedback
                let vibration = UIImpactFeedbackGenerator(style: .medium)
                vibration.impactOccurred()
                
                //refresh view
                refresh(scrollView: scrollView)
            }
            
            //if user swipes down quickly
            guard !(gesture.velocity(in: scrollView.superview).y > 120) else{
                normalize(scrollView: scrollView)
                return
            }
            
            //if user swipes up really quick
            if(gesture.velocity(in: scrollView.superview).y < -120 && scrollView.frame.origin.y > 100) {
                unNormalize(scrollView: scrollView)
            }
        default: break
        }
    }
    
    
    
}
