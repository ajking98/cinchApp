//
//  ProfileViewController.swift
//  InstagramClone
//
//  Created by Gedi, Ahmed M on 4/11/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import Cards

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var customImageFlowLayout: CustomImageFlowLayout!
    var photoCategories = PhotoCategory.fetchPhotos()
    // var folders = ["family", "foods", "travel", "nature"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ProfileCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        
        return cell
    }
    
    
    @IBOutlet var wallpaperImage: UIImageView!
    @IBOutlet var overlayProfileView: UIView!
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
        
        customImageFlowLayout = CustomImageFlowLayout()
        collectionView.collectionViewLayout = customImageFlowLayout
        
        let card = CardHighlight(frame: CGRect(x: overlayProfileView.frame.minX + 30, y: overlayProfileView.frame.maxY + wallpaperImage.frame.maxY - 10, width: 120, height: 144))
        card.backgroundColor = UIColor(red: 0, green: 94/255, blue: 112/255, alpha: 1)
        card.title = ""
        card.hasParallax = true
        card.backgroundImage = UIImage(named: "minions")
        card.textColor = .white
        card.buttonText = ""
        card.itemTitle = "Random"
        card.itemTitleSize = 40
        card.itemSubtitle = ""
        let cardContentVC = storyboard!.instantiateViewController(withIdentifier: "CardContent")
        card.shouldPresent(cardContentVC, from: self, fullscreen: false)
        view.addSubview(card)


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

