//
//  FolderContent.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 10/19/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit

class FolderContent: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = .lightGreen
        return cell
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var content : [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sizes and spaces the cells
        buildCollectionView()
        
        buildExitButton() //creates an exit button and adds it to the view
    }
    
    
    func buildExitButton() {
        let width = view.frame.width
        let height = view.frame.height
        let exitButton = UIButton(frame: CGRect(x: 20, y: height * 0.75, width: width / 1.5, height: width / 6))
        exitButton.setTitle("exit", for: .normal)
        exitButton.backgroundColor = .purple
        print("reached: ", exitButton.frame)
        exitButton.center.x = view.center.x
        exitButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleExit)))
        view.addSubview(exitButton)
    }
    
    
    @objc func handleExit(_ tapGesture : UITapGestureRecognizer? = nil) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //sizes and spaces the cells
    func buildCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let screenWidth = collectionView.frame.width - 3
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        collectionView!.collectionViewLayout = layout
        collectionView.showsVerticalScrollIndicator = false
    }
    
    
    
    
    ///gets posts from Firebase
    func grabContent() {
        
//        FolderStruct().readContent(user: <#T##String#>, folderName: <#T##String#>, completion: <#T##([String : String]) -> Void#>)
    }
}
