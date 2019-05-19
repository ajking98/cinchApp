//
//  HomeCollectionViewController.swift
//  Discover Page
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
    var icon = UIImage(named: "family")
    var longPressedBool = false
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
            blackBackgroundView?.layer.name = "black_background"
            keyWindow.addSubview(blackBackgroundView!)
            blackBackgroundView?.isUserInteractionEnabled = true
            blackBackgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
            zoomingImageView?.layer.name = "zooming_image_view"
            keyWindow.addSubview(zoomingImageView!)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
                
                //logic to get height
                var height = (startingImageView.image?.size.height)! / (startingImageView.image?.size.width)! * keyWindow.frame.width
                if (height > keyWindow.frame.height * 0.9) {
                    height = keyWindow.frame.height * 0.88
                }
                
                
                print((startingImageView.image?.size.height)!, "is the height" )
                print((startingImageView.image?.size)! )
                
                self.zoomingImageView?.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                self.zoomingImageView?.center = keyWindow.center
            }, completion: nil)
        }
        
    }
    
    @objc func longPressed(tapGesture: UILongPressGestureRecognizer)
    {
        guard tapGesture.state == .began else{
            return
        }
        //if long press has not been pressed before
        if let keyWindow = UIApplication.shared.keyWindow {
            guard longPressedBool else {
                
                
                let iconsView = UIImageView(frame: CGRect(x: keyWindow.frame.width - 100, y: 10, width: 100, height: 0))
                iconsView.image = icon
                blackBackgroundView?.backgroundColor = .lightGray
                iconsView.layer.name = "icons_view"
                keyWindow.addSubview(iconsView)
                
                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {
                    iconsView.frame = CGRect(x: keyWindow.frame.width - 100, y: 10, width: 100, height: 200)
                    self.zoomingImageView?.frame = CGRect(x:0, y:0, width: keyWindow.frame.width * 0.95, height: (self.zoomingImageView?.frame.height)! * 0.95)
                    self.zoomingImageView?.layer.cornerRadius = 8
                    self.zoomingImageView?.layer.masksToBounds = true
                    self.zoomingImageView?.center = keyWindow.center
                }, completion: { (completed: Bool) in
                    //medium level vibration feedback
                    let vibration = UIImpactFeedbackGenerator(style: .medium)
                    vibration.impactOccurred()
                })
                longPressedBool = true
                return
            }
            
            //TODO long click is registering two long clicks instead of one, find reason and fix, then uncomment next line
            //        longPressedBool = false
            
            //        TODO reverse the animation back up
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                for item in keyWindow.layer.sublayers! {
                    if(item.name == "icons_view"){
                        item.frame = CGRect(x: keyWindow.frame.width - 100, y: 10, width: 100, height: 0)
                    }
                }
            }) { (Bool) in
                //after completion
            }
            
        }
        
        
        //Downloads image
        var downloader = Download()
        let alert = downloader.downloadImage(targetImage: self.zoomingImageView!.image!)
        self.present(alert, animated: true, completion: nil)
        
        
        
        
        //        print(blackBackgroundView?.layer.name, "is the name of the layer")
        //        blackBackgroundView?.layer.name = "blackbackgorund"
        
        //        blackBackgroundView?.removeFromSuperview()
        //Different code
        
    }

    
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        longPressedBool = false
        if tapGesture.view != nil {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.zoomingImageView?.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
            }, completion: { (completed: Bool) in
                self.zoomingImageView?.removeFromSuperview()
                
            })
        }
    }
    
    @IBAction func loadButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "nextView", sender: self)
        //tabBarController?.selectedIndex = 1
    }
}
