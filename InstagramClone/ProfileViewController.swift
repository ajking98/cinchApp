//
//  ProfileViewController.swift
//  InstagramClone
//
//  Created by Gedi, Ahmed M on 4/11/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var photoCategories = PhotoCategory.fetchPhotos()
    // var folders = ["family", "foods", "travel", "nature"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ProfileCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        cell.imageView.image = UIImage(named: "folderImage")
        
        return cell
    }
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBAction func followAction(_ sender: UIButton) {
    }
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = 27
        profileImage.clipsToBounds = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        

        // Do any additional setup after loading the view.
    }


}

/*extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        cell.backgroundColor = UIColor.red
        return cell
    }
 
 }
 */

