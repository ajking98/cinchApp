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

struct Item {
    var imageName : String
}

struct ImageInsta {
    let key:String!
    let url:String!
    
    let itemRef:DatabaseReference?
    
    init(url:String, key:String) {
        self.key = key
        self.url = url
        self.itemRef = nil
    }
    
    init(snapshot:DataSnapshot) {
        key = snapshot.key
        itemRef = snapshot.ref
        
        let snapshotValue = snapshot.value as? NSDictionary
        
        if let imageUrl = snapshotValue?["url"] as? String {
            url = imageUrl
        } else {
            url = ""
        }
    }
    
    
}

class MessagesViewController: MSMessagesAppViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let defaults = UserDefaults(suiteName: "group.InstagramClone.messages")
    var message:MSMessage?
    var images:[UIImage] = []
    let cellIdentifier = "ContentCell"
    var objectImages:[String] = []
    var content = [ImageInsta]()
    @IBOutlet weak var searchView: UIView!
    
    var dbRef: DatabaseReference!
    let imageCache = NSCache<NSString, AnyObject>()
    
    @IBOutlet weak var collectionView: UICollectionView!
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(FirebaseApp.app() == nil){
            FirebaseApp.configure()
            dbRef = Database.database().reference().child("images")
        }
        loadDB()
        setUpCollectionView()
        addSearchBar()
//        objectImages = ["f1","f2","f3"]
//        objectImages = ["https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/images%2FBSnzTeDsgaftbUCsqEVq?alt=media&token=33656ad4-6005-4d6f-aa55-df834f56826c", "https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/images%2Fwaterbend.mp4?alt=media&token=dd6fb189-03c2-4c3a-9f51-2559645e631a", "https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/images%2FmcUGFunXhglGeUAhKYGm?alt=media&token=8985c620-b16c-409b-804d-316f96e07e8d", "https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/images%2Ffire.mp4?alt=media&token=cb204eee-6444-407e-953c-a6367a8cc7e8"]
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        setupCollectionViewLayout()
        // Do any additional setup after loading the view.
        
    }
    
    
    func loadDB() {
        dbRef.observe(DataEventType.value, with: { (snapshot) in
            var newImages = [ImageInsta]()
            for imageInstaSnapshot in snapshot.children {
                let imageInstaObject = ImageInsta(snapshot: imageInstaSnapshot as! DataSnapshot)
                newImages.insert(imageInstaObject, at: 0)
            }
            self.content = newImages
            self.collectionView.reloadData()
        })
        
    }
    
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "MessageCard", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MessageCard
        designCell(cell: cell)
        let image = content[indexPath.row]
//        cell.imageView.sd_setImage(with: URL(string: image.url), placeholderImage: UIImage(named: "empty"))
        cell.buildPostCard(item: content[indexPath.row].url)
//        print("baby" + objectImages[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(content.count)
        print(indexPath.row)
        print(content[indexPath.row])
        let newImageView = UIImageView()
        let url = URL(string: content[indexPath.row].url)
        newImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
        print(url!)
        
        if let statusImageURL = content[indexPath.row].url {
            URLSession.shared.dataTask(with: url!) { (data, response, error) -> Void in
                if error != nil {
                    print(error)
                    return
                }
                print("hellooooo")
                let image = UIImage(data: data!)
                DispatchQueue.main.async(execute: { () -> Void in
                    self.activeConversation?.insertAttachment(URL(fileURLWithPath: self.content[indexPath.row].url), withAlternateFilename: "\(self.content[indexPath.row])", completionHandler: nil)
                })
            }.resume()
        }
//        activeConversation?.insertAttachment(URL(fileURLWithPath: "/Users/cinch/Desktop/cinchApp/Gems/Assets.xcassets/testImages/\(objectImages[indexPath.row]).imageset/\(objectImages[indexPath.row]).jpg"), withAlternateFilename: "\(objectImages[indexPath.row])", completionHandler: nil)
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
    
    func run(cell: MessageContentCVCell) {
        let lay = MSMessageTemplateLayout()
        //        lay.image = cell.imageView.image
        let message = MSMessage()
        message.layout = lay
        
        activeConversation?.insert(message, completionHandler: nil)
    }
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
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
