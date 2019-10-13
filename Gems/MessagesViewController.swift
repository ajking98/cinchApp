//
//  MessagesViewController.swift
//  Gems
//
//  Created by Ahmed Gedi on 7/17/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let defaults = UserDefaults(suiteName: "group.InstagramClone.messages")
    var message:MSMessage?
    var images:[UIImage] = []
    let cellIdentifier = "ContentCell"
    var objectImages:[String] = []
    @IBOutlet weak var searchView: UIView!
    var stickers = [MSSticker]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchBar()
        objectImages = ["https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/images%2FBSnzTeDsgaftbUCsqEVq?alt=media&token=33656ad4-6005-4d6f-aa55-df834f56826c", "https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/images%2FBSnzTeDsgaftbUCsqEVq?alt=media&token=33656ad4-6005-4d6f-aa55-df834f56826c"]
        
        
        
        activeConversation?.insert(stickers[0], completionHandler: nil)
//        let lay = MSMessageTemplateLayout()
//        lay.image = image
//        let message = MSMessage()
//        message.layout = lay
//
//        activeConversation?.insert(message, completionHandler: nil)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        setupCollectionViewLayout()
        // Do any additional setup after loading the view.
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objectImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MessageContentCVCell
        designCell(cell: cell)
        cell.imageView.image = UIImage.init(named: objectImages[indexPath.row])
        print(objectImages[indexPath.row])
//        cell.isUserInteractionEnabled = true
////        let tapped = UITapGestureRecognizer(target: self, action: #selector(handleTap))
////        cell.addGestureRecognizer(tapped)
        images.append(UIImage.init(named: objectImages[indexPath.row])!)
        //        mc.message = message
        //        mc.activeConversation?.insert(message, completionHandler: nil)
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(images.count)
        print(indexPath.row)
        let layout = MSMessageTemplateLayout()
        layout.image = UIImage.init(named: objectImages[indexPath.row])
        let message = MSMessage()
        message.layout = layout
        
        let audioFileName:String = "/testImages/f1"
        let bundleURL = Bundle.main.bundleURL
        print(bundleURL)
        
        activeConversation?.insertAttachment(URL(fileURLWithPath: "/Users/cinch/Desktop/cinchApp/Gems/Assets.xcassets/testImages/\(objectImages[indexPath.row]).imageset/\(objectImages[indexPath.row]).jpg"), withAlternateFilename: "\(objectImages[indexPath.row])", completionHandler: nil)
//        activeConversation?.insert(message, completionHandler: nil)
    }
    
//    @objc func handleTap(cell: MessageContentCVCell) {
//        print("Tapped")
//        print(images.count)
//        let layout = MSMessageTemplateLayout()
//        layout.image = images[3]
//        let message = MSMessage()
//        message.layout = layout
//
//        activeConversation?.insert(message, completionHandler: nil)
//
//    }
    
    func addSearchBar() {
        let frame = searchView.frame
        var searchBar = SearchBar(frame: CGRect(x: 0, y: 0, width: frame.width * 1, height: 33))
        searchBar.placeholder = "Search"
        searchBar.center = CGPoint(x: searchView.center.x + 50, y: searchView.center.y)
        searchView.addGestureRecognizer(UITapGestureRecognizer(target: searchBar, action: #selector(searchBar.revertToNormal)))
        searchBar.backgroundColor = .white
        searchView.addSubview(searchBar)
    }

    func setupCollectionViewLayout() {
        let collectionViewLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: collectionView.frame.width / 2.4, height: collectionView.frame.width / 2.3)
            print(collectionView.frame.width)
            print(UIScreen.accessibilityFrame().width)
            return layout
        }()
        collectionView.collectionViewLayout = collectionViewLayout
    }
    
    func designCell(cell: MessageContentCVCell) {
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.95, alpha: 1.0).cgColor
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
