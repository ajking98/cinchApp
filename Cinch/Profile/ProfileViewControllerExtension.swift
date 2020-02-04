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
        cell.navigationController = self.navigationController
        return cell
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


extension ProfileMainCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 //TODO: This should be calling a list count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCollectionViewCell
        // For GemCollections
        if collectionView == self.gemsCollectionView {
//            let data = self.data[indexPath.item]
            cell.nameLabel.text = "Gem"
        }
        // For LikeCollections
        else {
            let cell = followingFoldersCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCollectionViewCell
//            let data = self.data[indexPath.item]
            cell.nameLabel.text = "Like Collection"
        }
        return cell
        
    }
    
    // TODO: Add function when content in profile collections get clicked
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ProfilePage", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FolderSelected") as! FolderSelectedController
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
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
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



