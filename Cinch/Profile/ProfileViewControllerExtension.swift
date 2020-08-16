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
        
        //TODO: put this is a delegate maybe
        cell.username = username
        cell.navigationController = self.navigationController
        
        
        if indexPath.item == 0 { //pulling from the uploaded folder
            cell.setupUploadedVC { (contentHeight) in
                let newHeight = self.view.frame.height + contentHeight + (self.tabBarController?.tabBar.frame.height)! +
                (self.navigationController?.navigationBar.frame.height)!
                
                if self.scrollView.contentSize.height < newHeight {
                    self.scrollView.contentSize.height = newHeight
                }
            }
        }
        else {
            cell.setupHeartedVC { (contentHeight) in
                let newHeight = self.view.frame.height + contentHeight + (self.tabBarController?.tabBar.frame.height)! +
                (self.navigationController?.navigationBar.frame.height)!
                
//                self.scrollView.contentSize.height = contentHeight
                if self.scrollView.contentSize.height < newHeight {
                    self.scrollView.contentSize.height = newHeight
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
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
            print("we have something", folderName)
            if folderName.lowercased() == "Hearted" {
                self.imageView.image = UIImage(named: "heartedFolder")
            } else {
                self.imageView.sd_setImage(with: url, placeholderImage: UIImage(), completed: nil)
            }
        }
        
        buildCell(username: username, folderName: folderName, isPersonal: isPersonal)
    }
    
    func buildCell(username: String, folderName: String, isPersonal: Bool) {
        //top image
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
        
        imageView.frame.size = CGSize(width: 0.9 * frame.width, height: frame.height * 0.87)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 3
        imageView.layer.borderWidth = 0.8
        imageView.layer.borderColor = UIColor.white.cgColor
        addSubview(imageView)
        print("sfesfaef \(folderName)")
        
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



