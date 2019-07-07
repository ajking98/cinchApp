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
    let cellIdentifier = "cellIdentifier"
    let objects = ["Cat", "Dog", "Fish"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dbRef = Database.database().reference().child(UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!).child("folders")
//        loadDB()
        self.collectionView.register(UINib(nibName: "GemsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GemsCollectionViewCell
        cell.title.text = self.objects[indexPath.row]
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
}
