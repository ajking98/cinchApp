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
import XLActionController


class HomeCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageCollection: UICollectionView!
    var customImageFlowLayout: CustomImageFlowLayout!
    var dbRef: DatabaseReference!
    var images = [ImageInsta]()
    var icon = UIImage(named: "download_icon")
    var save = UIImage(named: "add")
    var longPressedBool = false
    let imagePicker = UIImagePickerController()
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var zoomingImageView: UIImageView?
    var iconsView : UIView?
    var downloadIconView : UIImageView?
    var addIconView : UIImageView?
    
    
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
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            //creating iconsView
            iconsView = UIView(frame: CGRect(x: 10, y: UIScreen.main.bounds.height - 100, width: 200, height: 80))
            
            downloadIconView = UIImageView(frame: CGRect(x: 8, y:0, width: 75, height: 80))
            addIconView = UIImageView(frame: CGRect(x: 90, y: 0, width: 75, height: 80))
            
            downloadIconView!.image = icon
            addIconView!.image = save
            iconsView!.layer.name = "icons_view"
            iconsView!.isUserInteractionEnabled = true
            downloadIconView!.isUserInteractionEnabled = true
            addIconView?.isUserInteractionEnabled = true
        downloadIconView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(download(tapGesture:))))
            addIconView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveToFolder(tapGesture:))))
            
            iconsView?.addSubview(downloadIconView!)
            iconsView?.addSubview(addIconView!)
            keyWindow.addSubview(iconsView!)
            iconsView?.isHidden = true
        }
        
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
        cell.imageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLong)))
        
        return cell
        
    }
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        if let imageView = tapGesture.view as? UIImageView {
            self.performZoomInForStartingImageView(startingImageView: imageView)
        }
    }
    
    //TODO: finish long press
    @objc func handleLong(tapGesture: UILongPressGestureRecognizer) {
        print("has been long pressed")
    }
    
    
    func performZoomInForStartingImageView(startingImageView: UIImageView) {
        
        //selecting the target image and converting it to a frame
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView?.image = startingImageView.image
        zoomingImageView?.layer.name = "zooming_image_view"
       
        
        //adding gestures to zoomingImage
        zoomingImageView?.isUserInteractionEnabled = true
        zoomingImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        zoomingImageView?.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressed)))
        
            //adding swipe gestures to exit the zoomed image
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleZoomOut))
        swipeUp.direction = .up
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleZoomOut))
        swipeDown.direction = .down
        
        zoomingImageView?.addGestureRecognizer(swipeUp)
        zoomingImageView?.addGestureRecognizer(swipeDown)
        
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            
            //creating black background
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = .black
            blackBackgroundView?.alpha = 0
            blackBackgroundView?.layer.name = "black_background"
            blackBackgroundView?.isUserInteractionEnabled = true
        blackBackgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
            
            
            
            //adding swipe gestures to exit the zoomed image
            let swipeUp1 = UISwipeGestureRecognizer(target: self, action: #selector(handleZoomOut))
            swipeUp1.direction = .up
            
            let swipeDown1 = UISwipeGestureRecognizer(target: self, action: #selector(handleZoomOut))
            swipeDown1.direction = .down
            
            
            
            blackBackgroundView?.addGestureRecognizer(swipeUp1)
            blackBackgroundView?.addGestureRecognizer(swipeDown1)
            
            
            //adding subviews
            keyWindow.addSubview(blackBackgroundView!)
            keyWindow.addSubview(zoomingImageView!)
            
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.blackBackgroundView?.alpha = 1
                
                //logic to get height
                var height = (startingImageView.image?.size.height)! / (startingImageView.image?.size.width)! * keyWindow.frame.width
                if (height > keyWindow.frame.height * 0.9) { height = keyWindow.frame.height * 0.88  }
                
                //sizing and centering zoomingImage
                self.zoomingImageView?.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                self.zoomingImageView?.layer.cornerRadius = 8
                self.zoomingImageView?.layer.masksToBounds = true
                self.zoomingImageView?.center = keyWindow.center
            }, completion: nil)
        }
        
    }
    
    
    
    @objc func longPressed(tapGesture: UILongPressGestureRecognizer) {
        guard tapGesture.state == .began else{
            return
        }
        //if long press has not been pressed before
        if let keyWindow = UIApplication.shared.keyWindow {
            guard longPressedBool else {
                
                
                //medium level vibration feedback
                let vibration = UIImpactFeedbackGenerator(style: .heavy)
                vibration.impactOccurred()
                
                
                
                blackBackgroundView?.backgroundColor = .lightGray
                
                
                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {
                    self.zoomingImageView?.frame = CGRect(x:0, y:0, width: keyWindow.frame.width * 0.95, height: (self.zoomingImageView?.frame.height)! * 0.95)
                    self.zoomingImageView?.center = keyWindow.center
                    
                    self.iconsView?.isHidden = false
                    keyWindow.bringSubviewToFront(self.iconsView!)
                }, completion: { (completed: Bool) in
                })
                longPressedBool = true
                return
            }
            
        }
        
    }

    
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        guard (longPressedBool == false) else {
            exitLongPress()
            longPressedBool = false
            return
        }
        
        if tapGesture.view != nil {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.zoomingImageView?.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
            }, completion: { (completed: Bool) in
                self.zoomingImageView?.removeFromSuperview()
                
            })
        }
    }
    
    //Reset layout to before longPressed
    func exitLongPress(){
        longPressedBool = false
        
        //        TODO reverse the animation back up
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                
                for item in keyWindow.layer.sublayers! {
                    switch item.name {
                        
                    case "icons_view":
                        self.iconsView?.isHidden = true
                        
                    case "black_background":
                        item.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0, 0, 0, 1.0])
                        
                    case "zooming_image_view":
                        item.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: (self.zoomingImageView?.frame.height)! / 0.95)
                        item.position = keyWindow.center
                        
                    default:
                        print("defaulted: \(item.name)")
                    }
                }
            }) { (Bool) in
                //after completion
            }
        }
    }
    
    
    //downloads target image and alerts the user about download
    @objc func download(tapGesture: UITapGestureRecognizer){
        
        //Downloads image
        var downloader = Download()
        let alert = downloader.downloadImage(targetImage: self.zoomingImageView!.image!)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loadButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "nextView", sender: self)
        //tabBarController?.selectedIndex = 1
    }
    
    @objc func saveToFolder(tapGesture: UITapGestureRecognizer){
        
        var action = SpotifyActionController.init()
        if let image = zoomingImageView?.image {
            action = Helper().saveToFolder(image: image)
        }
        present(action, animated: true, completion: nil)
        
    }
}
