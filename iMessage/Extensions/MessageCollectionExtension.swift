//
//  MessageCollectionExtension.swift
//  iMessage
//
//  Created by Alsahlani, Yassin K on 2/7/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit
import Firebase


//Collection
extension MessagesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! BroadCollectionViewCell
        cell.dbRef = dbRef
        cell.setup(index: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.frame.size
    }
    
    
    
}

class BroadCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var index = 0
    let identifier = "Cell"
    var publicContent: [String] = []
    var personalContent: [String] = []
    var dbRef: DatabaseReference!
    var publicCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var personalCollectionview = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    func setup(index: Int) {
        if index == 0 {
            backgroundColor = .lightGray
            
            //publicCollectionView
            addSubview(publicCollectionView)
            publicCollectionView.frame = bounds
            publicCollectionView.register(GenericCell.self, forCellWithReuseIdentifier: identifier)
            publicCollectionView.delegate = self
            publicCollectionView.dataSource = self
            publicCollectionView.backgroundColor = .white
        }
        else {
            self.index = 1
            //personalCollectionView
            addSubview(personalCollectionview)
            personalCollectionview.frame = bounds
            personalCollectionview.register(GenericCell.self, forCellWithReuseIdentifier: identifier)
            personalCollectionview.delegate = self
            personalCollectionview.dataSource = self
        }
        fetchContent()
    }
    
    
    ///gets the links from the DB and appends it to the content array
    func fetchContent() {
        dbRef = Database.database().reference().child("posts")
        if index == 0 {
            dbRef.queryLimited(toLast: 60).queryOrdered(byChild: "dateCreated").observeSingleEvent(of: .value) { (snapshot) in

                for child in snapshot.children {
                    let child = child as? DataSnapshot
                    if let value = child?.key {
                        let indexPath = IndexPath(item: self.publicContent.count, section: 0)
                        self.publicContent.append(value)
                        self.publicCollectionView.insertItems(at: [indexPath])
                    } }
            }
        }
        else {
//            let username = UserDefaults(suiteName: "")
//            print("this is the username: ")
        }
    }
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if index == 0 {
            return publicContent.count
        }
        return personalContent.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! GenericCell
        if index == 0 {
            cell.setup(contentKey: publicContent[indexPath.item])
        }
        else {
            cell.setup(contentKey: personalContent[indexPath.item])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        iMessageDelegate.minimizeView()
        PostStruct().readLink(contentKey: publicContent[indexPath.item]) { (link) in
            guard let directory = saveContent(globalLink: link) else { return }
//            self.iMessageDelegate.mainConversation.insertAttachment(directory, withAlternateFilename: nil, completionHandler: nil)
        }
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


    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
          return true
      }
}
