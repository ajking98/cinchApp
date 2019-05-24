//
//  ProfileViewController.swift
//  Profile Page
/*
        1. User should be able to press and hold to move Folder order around
            1.5 The press and hold functionality should also give users the ability to rename and delete a folder (Similar to how you can press and hold an app)
 */
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
    let plus = UIImage(named: "plus")

    
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
        profileImage.layer.cornerRadius = 30
        profileImage.clipsToBounds = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        customImageFlowLayout = CustomImageFlowLayout()
        collectionView.collectionViewLayout = customImageFlowLayout
        
        
        //creating the card(s)
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
        card.shouldPresent(cardContentVC, from: self, fullscreen: true)
        
        //adding card to view
        view.addSubview(card)


        //getting screen dimensions
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        
            //creating the circle object and adding it to subview
            let outline = CGRect(x: screenWidth * 0.72, y: screenHeight * 0.75, width: 80, height: 80)
            let circleImg = UIImageView(frame: outline)
            circleImg.image = plus
            circleImg.layer.masksToBounds = false
            circleImg.layer.cornerRadius = outline.width / 2
            circleImg.clipsToBounds = true
            circleImg.layer.borderWidth = 1.5
            view.addSubview(circleImg)
            
            
            //adding functionality to the circleImg
            circleImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAdd)))
            circleImg.isUserInteractionEnabled = true

            print("FolderView")
        

    }
    
    
    //trigger the add folder function
    @objc func handleAdd(tapGesture: UITapGestureRecognizer) {
        print("working dog")
        var folderName : String = ""
        
        let alert = UIAlertController(title: "Name Your Folder", message: "Enter the name you wish to use for your folder", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            folderName = textField!.text!
            print("Text field: \(folderName)")
        }))
        self.present(alert, animated: true, completion: nil)
        
        //calling the function to save the folder name to Firebase and create it on the front end
        saveFolder(folderName : folderName)
        createFolder(folderName: folderName)
    }

    
    func saveFolder(folderName : String){
    
    print("saving Folder")
    }
    
    
    func createFolder(folderName: String){
    print("Creating folder: \(folderName)")
    }

}
