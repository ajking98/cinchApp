//
//  ReactionsViewController.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 6/23/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit


class MoodsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier = "MoodCell"
    let objectNames = ["Mad", "Sad", "Angry", "Love", "Jealousy"]
    let objectImages = ["n1", "n2", "n3", "n4", "n5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        setupCollectionViewLayout()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objectNames.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row + 1 < self.objectImages.count + 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MoodsCollectionViewCell
            designCell(cell: cell)
            cell.title.text = objectNames[indexPath.row]
            cell.imageView.image = UIImage.init(named: objectImages[indexPath.row])
            addSubviews(cell: cell)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Create", for: indexPath) as! AddFolderViewCell
            cell.addFolder.image = UIImage.init(named: "icons8-add-50")
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleAdd(tapGesture:)))
            cell.isUserInteractionEnabled = true
            cell.addGestureRecognizer(tapGestureRecognizer)
            
            return cell
        }
    }
    
    @objc func handleAdd(tapGesture: UITapGestureRecognizer) {
        print("working dog")
        var folderName : String = ""
        
        let alert = UIAlertController(title: "Name Your Folder", message: "Enter the name you wish to use for your folder", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            folderName = textField!.text!
            print("Text field: \(folderName)")
            let newFolder = Folder(folderName: folderName)
            //calling the function to save the folder name to Firebase and create it on the front end
//            UserStruct().addFolder(user: UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!, folder: newFolder)
            self.createFolder(folderName: folderName)
        }))
        
        alert.addAction(UIAlertAction(title:"Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveFolder(folderName : String){
        print("saving Folder")
    }
    
    
    func createFolder(folderName: String){
        print("Creating folder: \(folderName)")
        populateFolders()
    }
    
    
    //Should add all folder to FrontEnd
    //The parameter for this function should be an array of Folders (Create the Folders struct)
    func populateFolders(){
        print("Populating")
    }
    
    func setupCollectionViewLayout() {
        let collectionViewLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 5
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: 180, height: 180)
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

