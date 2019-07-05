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

class GemsViewController: UIViewController {
    
    var dbRef: DatabaseReference!
    var folderNames: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = Database.database().reference().child(UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!).child("folders")
        loadDB()
        let card = CardHighlight(frame: CGRect(x: 20, y: 0, width: 120, height: 144))
        card.backgroundColor = UIColor(red: 0, green: 94/255, blue: 112/255, alpha: 1)
        card.title = ""
        card.hasParallax = true
        card.backgroundImage = UIImage(named: "flappy")
        card.textColor = .white
        card.buttonText = ""
        card.itemTitle = "Random"
        card.itemTitleSize = 40
        card.itemSubtitle = ""
//        let storyboard = UIStoryboard(name: "GemsViewController", bundle: nil)
//        let cardContentVC = storyboard!.instantiateViewController(withIdentifier: "CardContent")
//        card.shouldPresent(cardContentVC, from: self, fullscreen: true)
        
        //adding card to view
        view.addSubview(card)
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
