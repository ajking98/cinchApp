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

class MessagesViewController: MSMessagesAppViewController {
    
    //data
    var width: CGFloat = 0
    var height: CGFloat = 0
    let identifier = "Cell"
    
    //views
    var searchBar = SearchBar(frame: CGRect(x: 0, y: 0, width: 310, height: 32.5))
    var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var tableTagsView = UITableView()
    
    //view controllers
    var searchTableViewController = SearchTableViewController(style: .plain)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setup()
        setupSearchBar()
        setupCollectionView()
        setupTableTagsView()
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
        
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.customRed]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
    }
    
    func setupTableTagsView() {
        view.addSubview(tableTagsView)
        tableTagsView.alpha = 0
        tableTagsView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        tableTagsView.dataSource = searchTableViewController
        tableTagsView.delegate = searchTableViewController
        tableTagsView.separatorStyle = .none
        
        //constraints
        tableTagsView.translatesAutoresizingMaskIntoConstraints = false
        tableTagsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableTagsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableTagsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableTagsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    

}
