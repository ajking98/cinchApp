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
    let hashTagIcon = UIImageView(image: UIImage(named: "HashTag"))
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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
         
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = .white
        addSubview(collectionView!)
         
        //constraints
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView?.widthAnchor.constraint(equalToConstant: cellWidth).isActive = true
        collectionView?.heightAnchor.constraint(equalToConstant: 0.68 * cellHeight).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0.07 * cellHeight).isActive = true
         
        collectionView?.contentInset.left = frame.width * 0.0387
         
        //add elements
        addHashTag()
        addTopText()
    }
    
    
    func addHashTag() {
        addSubview(hashTagIcon)
        let leftMargin = frame.width * 0.0387
        
        //constraints
        hashTagIcon.translatesAutoresizingMaskIntoConstraints = false
        hashTagIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: leftMargin).isActive = true
        hashTagIcon.widthAnchor.constraint(equalToConstant: 0.147 * cellHeight).isActive = true
        hashTagIcon.heightAnchor.constraint(equalToConstant: 0.147 * cellHeight).isActive = true
        hashTagIcon.topAnchor.constraint(equalTo: topAnchor, constant: 0.09 * cellHeight).isActive = true
    }
    
    func addTopText() {
        upperText.text = "supportaustraliasupport" //TODO this should be calling the database for tags
        upperText.textAlignment = .left
        addSubview(upperText)
        
        //constraints
        upperText.translatesAutoresizingMaskIntoConstraints = false
        upperText.leftAnchor.constraint(equalTo: hashTagIcon.rightAnchor, constant: 8).isActive = true
        upperText.widthAnchor.constraint(equalToConstant: 200).isActive = true
        upperText.bottomAnchor.constraint(equalTo: (collectionView?.topAnchor)!, constant: -8).isActive = true
        upperText.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        cell.backgroundColor = .lightGray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Discover", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CellSelected") as! CellSelectedTable
        vc.modalPresentationStyle = .fullScreen
        viewController?.present(vc, animated: true, completion: nil)
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