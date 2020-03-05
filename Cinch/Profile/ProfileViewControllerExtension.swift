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
        gemsCollectionView.register(FolderCell.self, forCellWithReuseIdentifier: cellIdentifier)
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
        followingFoldersCollectionView.register(FolderCell.self, forCellWithReuseIdentifier: cellIdentifier)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FolderCell
        // For Personal
        if collectionView == gemsCollectionView {
            cell.setup(username: username, folderName: folders[indexPath.item], isPersonal: true)
            return cell
        }
        // For Following
        cell.setup(username: foldersFollowing[indexPath.item].admin, folderName: foldersFollowing[indexPath.item].folderName, isPersonal: false)
        return cell
    }
    
    ///Presents the Folder Selected Controller
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FolderCell
        
        let storyboard = UIStoryboard(name: "ProfilePage", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FolderSelected") as! FolderSelectedController
        let folderName = cell.folderLabel.text!
        let username = collectionView == gemsCollectionView ? self.username : foldersFollowing[indexPath.item].admin
        vc.setup(username: username, folderName: folderName)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width) * 0.445 - 1.5, height: (collectionView.bounds.width) * 0.315)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = 0.04 * collectionView.frame.width
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
}

///Folder for the content on the Profile Page
class FolderCell: UICollectionViewCell {
    
    var username: String = ""
    var folderName: String = ""
    var isPersonal: Bool = false //when set to false, the profile icon will show on the folder along with the author's name
    
    //views
    var imageView = UIImageView(frame: CGRect.zero)
    var secondLayerView = UIView(frame: CGRect.zero)
    var thirdLayerView = UIView(frame: CGRect.zero)
    var profileIcon = UIImageView(frame: CGRect.zero)
    var folderLabel = UILabel(frame: CGRect.zero)
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    ///sets up the cell, takes the username, folderName, and whether or not the folder is owned by the user passed
    func setup(username: String, folderName: String, isPersonal: Bool) {
        folderLabel.text = folderName
        
        FolderStruct().readIcon(user: username, folderName: folderName) { (icon) in
            let url = URL(string: icon)
            self.imageView.sd_setImage(with: url, placeholderImage: UIImage(), completed: nil)
        }
        buildCell(username: username, folderName: folderName, isPersonal: isPersonal)
    }
    
    func buildCell(username: String, folderName: String, isPersonal: Bool) {
        //top image
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
        
        imageView.frame.size = CGSize(width: 0.89 * frame.width, height: frame.height * 0.84)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 3
        imageView.layer.borderWidth = 0.8
        imageView.layer.borderColor = UIColor.white.cgColor
        addSubview(imageView)
        
        //Gradient
        let topColor = UIColor.white.cgColor.copy(alpha: 0)
        let bottomColor = UIColor.black.cgColor.copy(alpha: 0.8)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = imageView.bounds
        imageView.layer.insertSublayer(gradientLayer, at: 0)
        
        
        //second layer
        secondLayerView.frame.size = imageView.frame.size
        secondLayerView.backgroundColor = .darkBlue
        secondLayerView.layer.borderColor = UIColor.white.cgColor
        secondLayerView.layer.borderWidth = 0.8
        secondLayerView.layer.cornerRadius = 3
        secondLayerView.frame.origin = CGPoint(x: 8, y: 8)
        insertSubview(secondLayerView, belowSubview: imageView)
        
        //third view
        thirdLayerView.frame.size = imageView.frame.size
        thirdLayerView.backgroundColor = .darkBlue
        thirdLayerView.layer.cornerRadius = 3
        thirdLayerView.frame.origin.x = secondLayerView.frame.origin.x + 8
        thirdLayerView.frame.origin.y = secondLayerView.frame.origin.y + 8
        insertSubview(thirdLayerView, belowSubview: secondLayerView)
        
        //folderLabel
        folderLabel.text = folderName
        folderLabel.textColor = .white
        folderLabel.font = folderLabel.font.withSize(14)
        
        //constraints for folderLabel
        imageView.addSubview(folderLabel)
        folderLabel.translatesAutoresizingMaskIntoConstraints = false
        folderLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: 8).isActive = true
        folderLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -4).isActive = true
        folderLabel.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: -4).isActive = true
        folderLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        guard !isPersonal else { return }
        
        //profile icon
        profileIcon.frame.size = CGSize(width: 30, height: 30)
        profileIcon.frame.origin = CGPoint(x: (self.imageView.frame.width - self.profileIcon.frame.width - 8), y: 8)
        profileIcon.backgroundColor = .lightGray
        profileIcon.layer.cornerRadius = profileIcon.frame.height / 2
        profileIcon.clipsToBounds = true
        imageView.addSubview(profileIcon)
        
        UserStruct().readProfilePic(user: username) { (link) in
            let url = URL(string: link)
            self.profileIcon.sd_setImage(with: url, placeholderImage: UIImage(), completed: nil)
        }
        
        UserStruct().readName(user: username) { (name) in
            print("this si the name:", name)
            self.folderLabel.text = "\(name)'s \(folderName)"
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



