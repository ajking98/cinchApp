//
//  ProfileViewControllerExtension.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 1/29/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit


extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("this is checking the count")
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProfileMainCollectionViewCell
        if indexPath.item == 0 {
            cell.setupFirstCollectionView()
        }
        else {
            cell.setupSecondCollectionView()
        }
        cell.username = username
        cell.navigationController = self.navigationController
        cell.fetchFolders()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("this is being used", indexPath.item)
        let index = 1 - indexPath.item
        segmentControl.selectedSegmentIndex = index
        handleSegmentTap()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        segmentControl.selectedSegmentIndex = indexPath.item
        handleSegmentTap()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}



class ProfileMainCollectionViewCell: UICollectionViewCell {
    let cellIdentifier = "Cell"
    var username = ""
    var folders: [String] = []
    var foldersFollowing: [FolderReference] = []
    
    //Elements
    var gemsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var followingFoldersCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var navigationController: UINavigationController!
    
    func setupFirstCollectionView() {
        gemsCollectionView.dataSource = self
        gemsCollectionView.delegate = self
        gemsCollectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        gemsCollectionView.showsVerticalScrollIndicator = false
        gemsCollectionView.alwaysBounceVertical = false
        gemsCollectionView.backgroundColor = .white
        gemsCollectionView.isScrollEnabled = false
        gemsCollectionView.frame = frame

        addSubview(gemsCollectionView)
    }
    
    func setupSecondCollectionView() {
        followingFoldersCollectionView.dataSource = self
        followingFoldersCollectionView.delegate = self
        followingFoldersCollectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        followingFoldersCollectionView.showsHorizontalScrollIndicator = false
        followingFoldersCollectionView.alwaysBounceVertical = false
        followingFoldersCollectionView.showsVerticalScrollIndicator = false
        followingFoldersCollectionView.backgroundColor = .white
        followingFoldersCollectionView.isScrollEnabled = false;
        followingFoldersCollectionView.frame = frame
        followingFoldersCollectionView.frame.origin.x = 0
        
        addSubview(followingFoldersCollectionView)
        
    }
}

//Represents the collection view that holds the cells for gems folders and following folders
extension ProfileMainCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    ///gets the names of the folders from firebase
    func fetchFolders() {
        print("this is the username", username)
        UserStruct().readFolders(user: username) { (folders) in
            self.folders = folders
            self.gemsCollectionView.reloadData()
        }
        UserStruct().readFoldersReference(user: username) { (folderRefs) in
            self.foldersFollowing = folderRefs
            self.followingFoldersCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == gemsCollectionView {
            print("this is the count of the gems: ", folders.count)
            return folders.count
        }
        return foldersFollowing.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCollectionViewCell
        // For GemCollections
        if collectionView == gemsCollectionView {
            cell.setup(username: username, folderName: folders[indexPath.item])
            return cell
        }
        
        // For LikeCollections
        cell.setup(username: foldersFollowing[indexPath.item].admin, folderName: foldersFollowing[indexPath.item].folderName)
        return cell
        
    }
    
    ///Presents the Folder Selected Controller
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProfileCollectionViewCell
        
        let storyboard = UIStoryboard(name: "ProfilePage", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FolderSelected") as! FolderSelectedController
        let folderName = cell.nameLabel.text!
        let username = collectionView == gemsCollectionView ? self.username : foldersFollowing[indexPath.item].admin
        vc.setup(username: username, folderName: folderName)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width)/3 - 1.5, height: (collectionView.bounds.width)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    
}

///Folder for the content on the Profile Page
class ProfileCollectionViewCell: UICollectionViewCell {
    
    var username: String = ""
    var folderName: String = ""
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setup(username: String, folderName: String) {
        nameLabel.text = folderName
        
        FolderStruct().readIcon(user: username, folderName: folderName) { (icon) in
            let url = URL(string: icon)
            let imageView = UIImageView(frame: self.frame)
            imageView.layer.opacity = 0.85
            imageView.sd_setImage(with: url, placeholderImage: UIImage(), completed: nil)
            self.backgroundView = imageView

            let gradient: CAGradientLayer = CAGradientLayer()

            gradient.colors = [UIColor.white.cgColor, UIColor.darkGray.cgColor]
            gradient.locations = [0.0 , 1.0]
            gradient.frame = self.frame

            self.layer.insertSublayer(gradient, at: 0)
        }
    }
    
    func fetchIcons() {
        print("this is fetching the icons: ", username, folderName)
    }
    
//    let picCollection: UIImageView = {
//        let image = UIImage(named: "example\(3)")
//        let imageView = UIImageView(image: image)
//        return imageView
//    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        backgroundColor = UIColor.lightGray
        
//        addSubview(picCollection)
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": picCollection]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": picCollection]))
        addSubview(nameLabel)
        
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



