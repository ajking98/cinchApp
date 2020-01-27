//
//  TableViewCell.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 1/26/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import UIKit


class TableViewCell: UITableViewCell, UICollectionViewDataSource {
    
    
    var cellHeight: CGFloat = 0
    var cellWidth: CGFloat = 0

    //elements
    let hashTagIcon = UIImageView(image: UIImage(named: "Hashtag"))
    let upperText = UILabel(frame: CGRect.zero)
    var identifier = "Cell"
    var collectionView: UICollectionView?
    var viewController: UIViewController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp() {
        print("this is setting up")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        cell.backgroundColor = .lightGray
        return cell
    }
}




extension UITableViewCell: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 0.28 * frame.width, height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.8
    }
}
