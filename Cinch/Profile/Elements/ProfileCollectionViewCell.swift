//
//  ProfileCollectionViewCell.swift
//  Cinch
//
//  Created by Guest User 2 on 6/6/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit


class ProfileMainCollectionViewCell: UICollectionViewCell {
    let cellIdentifier = "Cell"
    var username = ""
    var uploaded: [String] = []
    var hearted: [String] = []
    
    //Elements
    var uploadedCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var heartedCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var navigationController: UINavigationController!
    
    func setupUploadedVC(completion: @escaping(CGFloat)->Void) {
        uploadedCollectionView.dataSource = self
        uploadedCollectionView.delegate = self
        uploadedCollectionView.register(GenericCell.self, forCellWithReuseIdentifier: cellIdentifier)
        uploadedCollectionView.showsVerticalScrollIndicator = false
        uploadedCollectionView.alwaysBounceVertical = false
        uploadedCollectionView.backgroundColor = .white
        uploadedCollectionView.isScrollEnabled = false
        uploadedCollectionView.frame = frame
        self.uploadedCollectionView.backgroundColor = .lightGray
        let emptyFieldText = UILabel()
        
        //reading uploaded content
        FolderStruct().readContent(user: username, folderName: "Uploaded") { (content) in
            self.uploaded = content
            if content.count > 0 {
                emptyFieldText.removeFromSuperview()
            }
            if content.count > 6 {
                var extendedHeight = CGFloat((content.count / 3) - 2)
                extendedHeight *= self.uploadedCollectionView.frame.size.width / 2
                completion(extendedHeight)
            }
            self.uploadedCollectionView.reloadData()
        }
        
        addSubview(uploadedCollectionView)
        
        //Text for when the section is empty
        emptyFieldText.numberOfLines = 0
        emptyFieldText.textAlignment = .center
        emptyFieldText.frame.size.height = 80
        emptyFieldText.frame.size.width = 300
        emptyFieldText.text = "This Section is Empty. Go Upload A Meme"
        emptyFieldText.center.x = uploadedCollectionView.center.x
        
        uploadedCollectionView.addSubview(emptyFieldText)
    }
    
    func setupHeartedVC(completion: @escaping(CGFloat)->Void) {
        heartedCollectionView.dataSource = self
        heartedCollectionView.delegate = self
        heartedCollectionView.register(GenericCell.self, forCellWithReuseIdentifier: cellIdentifier)
        heartedCollectionView.showsHorizontalScrollIndicator = false
        heartedCollectionView.alwaysBounceVertical = false
        heartedCollectionView.showsVerticalScrollIndicator = false
        heartedCollectionView.backgroundColor = .white
        heartedCollectionView.isScrollEnabled = false;
        heartedCollectionView.frame = frame
        heartedCollectionView.frame.origin.x = 0
        self.heartedCollectionView.backgroundColor = .lightGray
        let emptyFieldText = UILabel()
        
        
        //reading hearted content
        FolderStruct().readContent(user: username, folderName: "Hearted") { (content) in
        self.hearted = content
        if content.count > 0 {
            emptyFieldText.removeFromSuperview()
        }
        if content.count > 6 {
            var extendedHeight = CGFloat((content.count / 3) - 2)
            let cellHeight = self.heartedCollectionView.frame.size.width / 2
            extendedHeight *= cellHeight
            extendedHeight += cellHeight
            completion(extendedHeight)
        }
        self.heartedCollectionView.reloadData()
        }
        
        addSubview(heartedCollectionView)
        
        //Text for when the section is empty
        emptyFieldText.text = "This Section is Empty. Go Like More Memes"
        emptyFieldText.numberOfLines = 0
        emptyFieldText.textAlignment = .center
        emptyFieldText.frame.size.height = 80
        emptyFieldText.frame.size.width = 300
        emptyFieldText.center.x = heartedCollectionView.center.x
        
        heartedCollectionView.addSubview(emptyFieldText)
        
    }
}

//Represents the collection view that holds the cells for gems folders and following folders
extension ProfileMainCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    ///returns the number of items in
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == uploadedCollectionView {
            return uploaded.count
        }
        return hearted.count
    }

    
    ///returns the image
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GenericCell
        cell.backgroundColor = .white
        
        // For uploaded
        if collectionView == uploadedCollectionView {
            cell.setup(contentKey: uploaded[indexPath.item])
            return cell
        }
//        // For hearted
        cell.setup(contentKey: hearted[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = CellSelectedTable()
        vc.modalPresentationStyle = .fullScreen
        vc.content = collectionView == uploadedCollectionView ? uploaded : hearted
        vc.startingIndex = indexPath
        parentViewController?.navigationController?.pushViewController(vc, animated: true)
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
