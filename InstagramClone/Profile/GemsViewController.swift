//
//  GemsViewController.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 6/23/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.

import UIKit
import Cards
import FirebaseStorage
import FirebaseDatabase

class GemsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var dbRef: DatabaseReference!
    var folderNames: [String]?
    
    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier = "GemCell"
    let objectNames = ["Cat", "Dog", "Fish"]
    let objectImages = ["f1", "f2", "f3"]
    
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
        return self.objectNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GemsCollectionViewCell
        designCell(cell: cell)
        cell.title.text = objectNames[indexPath.row]
        cell.imageView.image = UIImage.init(named: objectImages[indexPath.row])
        addSubviews(cell: cell)
        let tapAddImage = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        cell.addImageButton.addGestureRecognizer(tapAddImage)
        
        return cell
        
    }
    
    func loadDB() {
        print("reached")
        // Not reading database properly
        dbRef.queryOrderedByKey().observe(.value, with: {
            snapshot in
            let value = snapshot.value as? NSDictionary
            print("hey")
            var yourArray = [String]()
            if let scores = snapshot.value as? NSDictionary{
                for i in 0..<scores.count {
                    yourArray.append(scores[i] as! String)
                    print(scores[i])
                }
            }
            self.folderNames = yourArray
        })
        
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
    
    @objc func handleTap(gesture: UITapGestureRecognizer) -> Void {
        print("Add Image to Folder")
    }
    
    func createBlurEffect() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }
    
    func addSubviews(cell: GemsCollectionViewCell) {
        let blurEffect = createBlurEffect()
        cell.overlayView.addSubview(blurEffect)
        cell.overlayView.addSubview(cell.addImageButton)
        cell.overlayView.addSubview(cell.title)
    }
    
    func designCell(cell: GemsCollectionViewCell) {
        cell.overlayView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        cell.title.textColor = UIColor(white: 1, alpha: 1)
        cell.title.font = UIFont(name: "Helvetica", size: 15)
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.95, alpha: 1.0).cgColor
        cell.clipsToBounds = true
    }
}
