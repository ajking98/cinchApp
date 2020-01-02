//
//  SearchResultCollectionView.swift
//  CinchIMessageExtension
//
//  Created by Alsahlani, Yassin K on 12/4/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import Messages
import AVKit
 

class SearchResultCollectionView: MSMessagesAppViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var collectionView: UICollectionView!
    private let reuseIdentifier = "ResultCell"
    var posts: [Post] = []
    
    var searchTerm = ""
    var mainActiveConversation: MSConversation?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setupCollectionViewLayout()
        fetchContent()
    }
    
    
    //
    func fetchContent() {
        ParentTagStruct().readTag(tagLabel: searchTerm) { (tag) in
            guard let elements = tag.tagElements else { return }
            
            //cycle through all the tag elements in the tag object
            for element in elements {
                do {
                    try ParentPostStruct().readPost(postLink: element.link, completion: { (post) in
                        let indexPath = IndexPath(item: self.posts.count, section: 0)
                        self.posts.append(post)
                        self.collectionView.insertItems(at: [indexPath])
                    })
                }
                catch {
                    print("messing up")
                }
            }
        }
    }
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "MessageCard", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
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
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCard
        guard let link = posts[indexPath.item].link else { return cell }
        cell.buildPostCard(link: link)
        designCell(cell: cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let link = posts[indexPath.item].link else { return } //gets the string version of the link
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
        
        mainActiveConversation?.insertAttachment(directory!, withAlternateFilename: nil, completionHandler: nil)
    }
    

}
