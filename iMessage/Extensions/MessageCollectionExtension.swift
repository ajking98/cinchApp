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
        cell.iMessageDelegate = self.iMessageDelegate
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.frame.size
    }
    
    
    
}

class BroadCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var index = 0
    let identifier = "Cell"
    var content: [String] = []
    var dbRef: DatabaseReference!
    var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var iMessageDelegate: iMessageAppDelegate!
    
    func setup(index: Int) {
        backgroundColor = .lightGray 
        
        //publicCollectionView
        addSubview(collectionView)
        collectionView.frame = bounds
        collectionView.register(GenericCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = index == 0 ? .white : .black
        
        //constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        fetchContent(index: index)
    }
    override func prepareForReuse() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        content = []
    }
    
    
    ///gets the links from the DB and appends it to the content array
    func fetchContent(index: Int) {
        dbRef = Database.database().reference().child("posts")
        if index == 0 {
            dbRef.queryLimited(toLast: 60).queryOrdered(byChild: "dateCreated").observeSingleEvent(of: .value) { (snapshot) in

                for child in snapshot.children {
                    let child = child as? DataSnapshot
                    if let value = child?.key {
                        let indexPath = IndexPath(item: self.content.count, section: 0)
                        self.content.append(value)
                        self.collectionView.insertItems(at: [indexPath])
                    } }
            }
        }
        else {
            guard let username = UserDefaults(suiteName: "group.cinch")?.string(forKey: defaultsKeys.usernameKey) else { return }
            UserStruct().readCompleteFolders(user: username) { (folders) in
                for folder in folders {
                    for (contentKey, link) in folder.content {
                        let indexPath = IndexPath(item: self.content.count, section: 0)
                        self.content.append(contentKey)
                        self.collectionView.insertItems(at: [indexPath])
                    }
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! GenericCell
        cell.setup(contentKey: content[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        iMessageDelegate.minimizeView()
        PostStruct().readLink(contentKey: content[indexPath.item]) { (link) in
            guard let directory = saveContent(globalLink: link) else { return }
            self.iMessageDelegate.mainConversation.insertAttachment(directory, withAlternateFilename: nil, completionHandler: nil)
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
