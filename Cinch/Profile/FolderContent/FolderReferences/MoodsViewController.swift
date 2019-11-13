//
//  ReactionsViewController.swift
//  Cinch
//
//  Created by Ahmed Gedi on 6/23/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import SDWebImage


class FolderReferenceController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier = "MoodCell"
    var folderRefs : [FolderReference] = []
    var username = ""
    var isLocalUser = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if username == "" {
            username = String(UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!)
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        setupCollectionViewLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchFolders()
    }
    
    ///fetches all folder References for the given user
    func fetchFolders() {
        UserStruct().readFoldersReference(user: username) { (folderReferences) in
            for folderRef in folderReferences {
                print("this is aref")
                let indexPath = IndexPath(item: self.folderRefs.count, section: 0)
                self.folderRefs.append(folderRef)
                self.collectionView.insertItems(at: [indexPath])
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //If the user isn't currently following any folders
        let messageView = UILabel(frame: collectionView.frame)
        
        messageView.text = "Folders you follow will appear here"
        messageView.textAlignment = .center
        messageView.backgroundColor = .darkerGreen
        messageView.tag = 100 //random number assigned to messageview
        messageView.textColor = .white
        messageView.center = CGPoint(x: collectionView.center.x, y: collectionView.center.y - 40)
        collectionView.backgroundView = messageView
        
        if folderRefs.count > 0 {
            collectionView.backgroundView = UIView(frame: collectionView.frame)
        }
        
        print("this is the count", folderRefs.count)
        return folderRefs.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FolderCotent") as! FolderContent
        
        vc.folderName = folderRefs[indexPath.row].folderName
        vc.username = username
        vc.isLocalUser = isLocalUser
        
        let myNav = UINavigationController(rootViewController: vc)
        present(myNav, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MoodsCollectionViewCell
        designCell(cell: cell)
        
        let folderRef = folderRefs[indexPath.row]
        let username = folderRef.admin
        let folderName = folderRef.folderName
        
        cell.title.text = folderName
        
        //TODO this should store the number of elements inside the folder
        cell.contentNumber.text = username
        
        FolderStruct().readIcon(user: username, folderName: folderName) { (link) in
            let url = URL(string: link)
            cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "n2"), completed: nil)
        }
        return cell
    }
    
    func setupCollectionViewLayout() {
        let collectionViewLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 5
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: view.frame.width / 2.3, height: view.frame.width / 2.3)
            return layout
        }()
        collectionView.collectionViewLayout = collectionViewLayout
    }
    
    func createBlurEffect() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }
    
    func addSubviews(cell: MoodsCollectionViewCell) {
        let blurEffect = createBlurEffect()
        cell.overlayView.addSubview(blurEffect)
        cell.overlayView.addSubview(cell.contentNumber)
        cell.overlayView.addSubview(cell.title)
    }
    
    func designCell(cell: MoodsCollectionViewCell) {
        cell.overlayView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        cell.title.textColor = UIColor(white: 1, alpha: 1)
        cell.title.font = UIFont(name: "Helvetica", size: 15)
        cell.contentNumber.textColor = UIColor(white: 1, alpha: 1)
        cell.contentNumber.font = UIFont(name: "Helvetica", size: 15)
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.95, alpha: 1.0).cgColor
        cell.clipsToBounds = true
    }
    
}

