//
//  MessagesViewController.swift
//  Gems
//
//  Created by Ahmed Gedi on 7/17/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
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
        dbRef.observeSingleEvent(of: .value) { (snapshot) in
            if let listOfPosts = snapshot.value as? [String : [String : Any]] {
                for singlePost in listOfPosts{
                    
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
        cell.buildPostCard(item: content[indexPath.row])
        
        designCell(cell: cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = URL(string: content[indexPath.row])  //gets the url of the image
        print(url)
        let newImageView = UIImageView()
        newImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
        
        guard let directory = saveImage(imageName: "SelectedImage.jpg", image: newImageView.image!) else { return }
        activeConversation?.insertAttachment(directory, withAlternateFilename: nil, completionHandler: nil)
    }
    
    
    ///saves the image locally, to the user's device, before being sent over
    func saveImage(imageName: String, image: UIImage)->URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        guard let data = image.jpegData(compressionQuality: 1) else { return nil }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
        return fileURL
    }
    
    func addSearchBar() {
        let frame = searchView.frame
        var searchBar = SearchBar(frame: CGRect(x: 0, y: 0, width: frame.width * 1, height: 33))
        searchBar.placeholder = "Search"
        searchBar.center = CGPoint(x: searchView.center.x + 50, y: searchView.center.y)
        searchView.addGestureRecognizer(UITapGestureRecognizer(target: searchBar, action: #selector(searchBar.revertToNormal)))
        searchBar.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        searchView.addSubview(searchBar)
    }
    
    func setupCollectionViewLayout() {
        let collectionViewLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: collectionView.frame.width / 2.35, height: collectionView.frame.width / 2.3)
            print(collectionView.frame.width)
            print(UIScreen.accessibilityFrame().width)
            return layout
        }()
        collectionView.collectionViewLayout = collectionViewLayout
    }
    
    func designCell(cell: MessageCard) {
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.white.cgColor
        cell.clipsToBounds = true
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
