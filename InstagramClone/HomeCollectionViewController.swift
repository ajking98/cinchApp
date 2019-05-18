//
//  HomeCollectionViewController.swift
//  InstagramClone
//
//  Created by Gedi, Ahmed M on 4/14/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage
import Photos

class HomeCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageCollection: UICollectionView!
    var customImageFlowLayout: CustomImageFlowLayout!
    var dbRef: DatabaseReference!
    var images = [ImageInsta]()
    let imagePicker = UIImagePickerController()
    //var tabBarController: UITabBarController? { get }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        // create a reference to the database
        dbRef = Database.database().reference().child("images")
        loadDB()
        
        imageCollection.alwaysBounceVertical = true
        imageCollection.indicatorStyle = .white
        customImageFlowLayout = CustomImageFlowLayout()
        imageCollection.collectionViewLayout = customImageFlowLayout
        imageCollection.backgroundColor = .white
    }
    
    func loadDB() {
        dbRef.observe(DataEventType.value, with: { (snapshot) in
            var newImages = [ImageInsta]()
            for imageInstaSnapshot in snapshot.children {
                let imageInstaObject = ImageInsta(snapshot: imageInstaSnapshot as! DataSnapshot)
                newImages.append(imageInstaObject)
            }
            self.images = newImages
            self.imageCollection.reloadData()
        })
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeCollectionViewCell
        let image = images[indexPath.row]
        cell.imageView.sd_setImage(with: URL(string: image.url), placeholderImage: UIImage(named: "empty"))
        cell.imageView.isUserInteractionEnabled = true
        cell.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        
        return cell
        
    }
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        if let imageView = tapGesture.view as? UIImageView {
            self.performZoomInForStartingImageView(startingImageView: imageView)
        }
        
    }
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var zoomingImageView: UIImageView?
    func performZoomInForStartingImageView(startingImageView: UIImageView) {
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView?.image = startingImageView.image
        //zoomingImageView?.backgroundColor = .red
       
        zoomingImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        zoomingImageView?.isUserInteractionEnabled = true
    zoomingImageView?.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressed)))
        
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = .black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            blackBackgroundView?.isUserInteractionEnabled = true
            blackBackgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
            keyWindow.addSubview(zoomingImageView!)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                self.zoomingImageView?.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                self.zoomingImageView?.center = keyWindow.center
                }, completion: nil)
        }
    }
    
    @objc func longPressed(tapGesture: UILongPressGestureRecognizer)
    {
        print("longpressed")
        //Different code
        
    }

    
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        if tapGesture.view != nil {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.zoomingImageView?.removeFromSuperview()
                self.blackBackgroundView?.alpha = 0
            }, completion: { (completed: Bool) in
            })
        }
    }
    
    
    @IBAction func loadButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "nextView", sender: self)
        //tabBarController?.selectedIndex = 1
    }
}
