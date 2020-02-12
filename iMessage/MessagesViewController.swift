//
//  MessagesViewController.swift
//  iMessage
/*
    Add search Bar to navigation bar
    Add collectionview to entire view
    Add searchview to iMessage
    Pressing search should trigger the next view
 */
//  Created by Alsahlani, Yassin K on 2/6/20.
//

import UIKit
import Messages
import Firebase

class MessagesViewController: UIViewController {
    
    //data given by the presenting view
    var iMessageDelegate: iMessageAppDelegate!
    
    //data
    var width: CGFloat = 0
    var height: CGFloat = 0
    let identifier = "Cell"
    var content:[String] = []
    var dbRef: DatabaseReference!

    //views
    var searchBar = SearchBar(frame: CGRect(x: 0, y: 0, width: 310, height: 32.5))
    var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var tableTagsView = UITableView()
    
    //view controllers
    var searchTableViewController = SearchTableViewController(style: .plain)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(FirebaseApp.app() == nil){
            FirebaseApp.configure()
        }
        
        setup()
        fetchContent()
        setupSearchBar()
        setupCollectionView()
        setupTableTagsView()
    }
    
    ///gets the links from the DB and appends it to the content array
    func fetchContent() {
        dbRef = Database.database().reference().child("posts")
        dbRef.queryLimited(toFirst: 60).queryOrdered(byChild: "dateCreated").observeSingleEvent(of: .value) { (snapshot) in
            
                for child in snapshot.children {
                    let child = child as? DataSnapshot
                    if let value = child?.value as? [String : Any] {
                        if let link = value["link"] as? String {
                            let indexPath = IndexPath(item: self.content.count, section: 0)
                            self.content.append(link)
                            self.collectionView.insertItems(at: [indexPath])
                        } } }
        }
    }
    
    func setup(){
        width = view.frame.width
        height = view.frame.height
        
    }
    
    func setupSearchBar() {
        searchBar.setup(width)
        searchBar.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.customRed]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
    }
    
    func setupTableTagsView() {
        view.addSubview(tableTagsView)
        tableTagsView.alpha = 0
        tableTagsView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        tableTagsView.dataSource = searchTableViewController
        tableTagsView.delegate = searchTableViewController
        searchTableViewController.handleCellSelected = nextView(term:)
        tableTagsView.separatorStyle = .none
        
        //constraints
        tableTagsView.translatesAutoresizingMaskIntoConstraints = false
        tableTagsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableTagsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableTagsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableTagsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    ///presents the next vc when the user enters a term to search 
    func nextView(term: String) {
        searchTableViewController.addSearchTerm(term: term)
        tableTagsView.alpha = 0
        searchBar.endEditing(true)
        let vc = MessageSearchResultsViewController()
        vc.initialNavigationController = navigationController
        vc.setup(term: term)
        vc.iMessageDelegate = iMessageDelegate
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupCollectionView() {
        collectionView.register(GenericCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset.top = 16
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        //constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }

}


protocol iMessageAppDelegate {
    func expandView()
    func minimizeView()
    func getPresentationStyle() -> MSMessagesAppPresentationStyle
    var mainConversation: MSConversation { get }
}

