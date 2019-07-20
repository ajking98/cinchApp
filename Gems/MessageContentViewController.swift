//
//  MessageContentViewController.swift
//  Gems
//
//  Created by Ahmed Gedi on 7/17/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import Messages

class MessageContentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier = "ContentCell"
    let objectImages = ["f1", "f2", "f3", "f4", "f5"]
    var images:[UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.isUserInteractionEnabled = true
        let tapped = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        cell.addGestureRecognizer(tapped)
        images.append(cell.imageView.image!)
//        mc.message = message
//        mc.activeConversation?.insert(message, completionHandler: nil)
        
        
        return cell
        
    }
    
    @objc func handleTap(cell: MessageContentCVCell) {
        let mc = MessagesViewController()
        print("Tapped")
        mc.run(cell: cell)
        
    }

    func setupCollectionViewLayout() {
        let collectionViewLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 5
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: 130, height: 130)
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
}

