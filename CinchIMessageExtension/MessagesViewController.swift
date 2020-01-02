//
//  MessagesViewController.swift
//  Gems
//
//  Created by Ahmed Gedi on 7/17/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import AVKit
import Messages
import SDWebImage
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import Firebase
import SQLite


class MessagesViewController: MSMessagesAppViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    let cellIdentifier = "ContentCell"
    
    //Stores the links of the posts
    var content = [String]()
    @IBOutlet weak var searchView: UIView!
    
    //SearchBar
    let searchBar = SearchBariMessage(frame: CGRect(x: 0, y: 0, width: 0, height: 33))
    var suggestedSearchView : TableSearchViewController? //this is the view with all the suggestions
    
    var dbRef: DatabaseReference!
    
    let cache = NSCache<NSString, UIImage>()
    
    @IBOutlet weak var collectionView: UICollectionView!
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(FirebaseApp.app() == nil){
            FirebaseApp.configure()
        }
        
        dbRef = Database.database().reference().child("posts")
        fetchContent()
        
        
        setUpCollectionView()
        addSearchBar()
        setupCollectionViewLayout()
    }
    
    ///Updates the content array with values from the DB
    func fetchContent() {
        dbRef.queryLimited(toFirst: 100).queryOrdered(byChild: "dateCreated").observeSingleEvent(of: .value) { (snapshot) in
            if let listOfPosts = snapshot.value as? [String : [String : Any]] {
                for singlePost in listOfPosts{
                    print("this is the date: ", singlePost.value["dateCreated"])
                    if let link = singlePost.value["link"] as? String {
                    let indexPath = IndexPath(item: self.content.count, section: 0)
                    self.content.append(link)
                    self.collectionView.insertItems(at: [indexPath])
                    }
                }
            }
        }
    }
    
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "MessageCard", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MessageCard
        cell.buildPostCard(link: content[indexPath.row])
        designCell(cell: cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let link = content[indexPath.item] //gets the string version of the link
        guard let url = URL(string: link) else { return } //converts the link to an actual url
        var directory:URL?
        
        if (checkIfVideo(link: link)) { //handle video
            directory = (saveVideo(videoName: "SelectedVideo.mp4", linkToVideo: url))
        }
        else { //handle image
            if (link.contains("/videos")) { return } //checking to make sure the content is not a video
            directory = saveImage(imageName: "SelectedImage.jpg", linkToImage: url)
        }
        guard directory != nil else { return }
        
        activeConversation?.insertAttachment(directory!, withAlternateFilename: nil, completionHandler: nil)
    }
    
    
    
    func addSearchBar() {
        let frame = searchView.frame
        searchBar.frame.size.width = frame.width
        searchBar.placeholder = "Search"
        searchBar.center = CGPoint(x: searchView.center.x + 50, y: searchView.center.y)
        searchView.addGestureRecognizer(UITapGestureRecognizer(target: searchBar, action: #selector(searchBar.revertToNormal)))
        searchBar.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        searchBar.delegate2 = self
        searchBar.searchDelegate = self
        searchView.addSubview(searchBar)
    }
    
    
    func setupCollectionViewLayout() {
        let collectionViewLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: collectionView.frame.width / 2.6, height: collectionView.frame.width / 2.6)
            print(collectionView.frame.width)
            print(UIScreen.accessibilityFrame().width)
            return layout
        }()
        collectionView.collectionViewLayout = collectionViewLayout
    }
    
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        print("we are becoming active")
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
        
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
        
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
        
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
    
}

//the delegate
extension MessagesViewController: SearchDelegate, SearchiMessageDelegate {
    
    ///Exands the view to make it take up the whole screen
    func expandView() {
        requestPresentationStyle(.expanded)
    }
    
    
    func search(searchTerm: String) {
        let standardizedSearchTerm = searchTerm.lowercased()
        guard let suggestedSearchView = suggestedSearchView else { return }
        
        guard standardizedSearchTerm.count > 1 else {
                UIView.animate(withDuration: 0.2, animations: {
                    suggestedSearchView.view.layer.opacity = 0
                })
            return
        }
        
        //Calls the method within searchView that will update the words within the suggested hashtag searches
        suggestedSearchView.updateTagList(searchTerm: standardizedSearchTerm)
        UIView.animate(withDuration: 0.2) {
            suggestedSearchView.view.layer.opacity = 1
        }
        print("handling search")
    }
    
    
    //builds the table view for the search (to hold the suggested tag)
    func buildSearchView() {
        let width = view.frame.width
        let height = view.frame.height
        suggestedSearchView = TableSearchViewController(style: .plain)
        guard let suggestedSearchView = suggestedSearchView else { return }
        
        suggestedSearchView.view.layer.opacity = 0
        suggestedSearchView.view.frame = CGRect(x: 0, y: 0, width: width * 0.88, height: height * 0.2)
        suggestedSearchView.view.center.x = view.center.x
        suggestedSearchView.view.layer.cornerRadius = 10
        print("we are in fact doing this")
        suggestedSearchView.pendingFunction = presentTagElements(searchTerm:)
        suggestedSearchView.view.frame.origin.y = collectionView.frame.origin.y - 15
        view.addSubview(suggestedSearchView.view)
    }
    
    
    //this triggers the next view controller where the posts are from the tag they searched
    func presentTagElements(searchTerm : String) {
        let vc = UIStoryboard(name: "MainInterface", bundle: nil).instantiateViewController(withIdentifier: "SearchResult") as! SearchResultCollectionView
        vc.searchTerm = searchTerm
        vc.mainActiveConversation = self.activeConversation
        self.present(vc, animated: true, completion: nil)
    }
}
