//
//  MainDiscover.swift
//  Cinch
//
//  Created by Ahmed Gedi on 8/9/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit

class PrimaryDiscoverController: DiscoverController, SearchDelegate {
    
    var searchView : TableSearchViewController? //this is the view with all the suggestions
    var primarySearchTerm = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchBar()
        searchBar?.endEditing(true)
//        buildSearchView()
        addSelectBar(color: UIColor.normalBlue)
    }
    
    //this triggers the next view controller where the posts are from the tag they searched
    func presentTagElements(searchTerm : String) {
        let vc = UIStoryboard(name: "Discover", bundle: nil).instantiateViewController(withIdentifier: "SearchResult") as! SearchResultViewController
        vc.searchTerm = searchTerm
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //this gets the text as the user types into the textfield
    func search(searchTerm: String) {
        guard let searchView = searchView else { return }
        let standardizedSearchTerm = searchTerm.lowercased()
        
        guard standardizedSearchTerm.count > 1 else {
                UIView.animate(withDuration: 0.2, animations: {
                    searchView.view.layer.opacity = 0
                })
            return
        }
        
        //Calls the method within searchView that will update the words within the suggested hashtag searches
        searchView.updateTagList(searchTerm: standardizedSearchTerm)
        UIView.animate(withDuration: 0.2) {
            searchView.view.layer.opacity = 1
        }
    }
    
    func endSearchEditing() {
        guard let searchView = searchView else { return }
        UIView.animate(withDuration: 0.2, animations: {
            searchView.view.layer.opacity = 0
        })
        //resets the search bar back to normal if empty 
        searchBar?.revertToNormal()
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
        searchView.view.frame = CGRect(x: 0, y: 0, width: width * 0.88, height: height * 0.2)
        searchView.view.center.x = view.center.x
        searchView.view.layer.cornerRadius = 10
        searchView.pendingFunction = presentTagElements(searchTerm:)
        searchView.view.frame.origin.y = collectionView.frame.origin.y - 15
        view.addSubview(searchView.view)
    }
    
    func translateTables(_ translation: CGFloat) {
        collectionView.center.y += translation
        collectionView.frame.size.height -= translation
        
        tableView.center.y += translation
        tableView.frame.size.height -= translation
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        handleScrollEnded(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isRefreshing = false
    }
    
    func handleScrollEnded(_ scrollView : UIScrollView) {
        if isRefreshing {
            Helper().vibrate(style: .light)
            //after the refresh is complete, set the offset to zero
        
            fetchContent { (isCompleted) in
                print("we have fetched the content", self.posts.count)
                self.normalize(scrollView: scrollView)
                UIView.animate(withDuration: 0.2) {
                    self.loadingIcon.frame.size = CGSize(width: 0, height: 0)
                    self.loadingIcon.center = CGPoint(x: self.view.center.x, y: self.collectionView.frame.origin.y + 55)
                }
            }
        }
    }
    
    //when user scrolls in the scrollview, the view should pan and either move the segment control out the view or into the view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let gesture = scrollView.panGestureRecognizer
        guard !isRefreshing else { return }
        
        let contentOffset = scrollView.contentOffset.y
        if (contentOffset < -100){
            Helper().vibrate(style: .heavy)
            UIView.animate(withDuration: 0.2) {
                self.loadingIcon.frame.size = CGSize(width: 55, height: 55)
                self.loadingIcon.center = CGPoint(x: self.view.center.x, y: self.collectionView.frame.origin.y + 55)
            }
            print("exceeding 1")
            isRefreshing = true
        }
        else if contentOffset < -50{
            self.loadingIcon.frame.size = CGSize(width: contentOffset, height: contentOffset)
            self.loadingIcon.center = CGPoint(x: self.view.center.x, y: self.collectionView.frame.origin.y + 55)
        }
        else if self.loadingIcon.frame.width > 1 {
            UIView.animate(withDuration: 0.2) {
                self.loadingIcon.frame.size = CGSize(width: 0, height: 0)
                self.loadingIcon.center = CGPoint(x: self.view.center.x, y: self.collectionView.frame.origin.y + 55)
            }
        }
        
        
        //TODO clean this up
        switch gesture.state {
        case .began:
            endSearchEditing()
        case .changed:
            let translation = gesture.translation(in: scrollView.superview).y * 0.1
            
            
            //if the segment control is less than or equal to the normalized center, then continue
            guard (segmentControl.center.y + translation) <= segmentControlCenter!.y else {
                return
            }
            
            //if pan is in the negative direction and the segment control hasn't reached its peak height
            if (translation < 0 && segmentControl.center.y > (-10 - segmentControl.frame.height)){
                segmentControl.center.y += translation
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
//        case .ended:
//            if scrollView.contentOffset.y <= -50 && !isRefreshing {
//                print("reached refreshing")
//                isRefreshing = true
//            }
//
//            //if user swipes down quickly
//            guard !(gesture.velocity(in: scrollView.superview).y > 120) else{
//                print("Normalize")
//                normalize(scrollView: scrollView)
//                return
//            }
//
//            //if user swipes up really quick
//            if(gesture.velocity(in: scrollView.superview).y < -120 && scrollView.frame.origin.y > 100) {
//                print("unnormalize")
//                unNormalize(scrollView: scrollView)
//            }
        default: break
        }
    }
    
    
    
}
