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
    var blackBackgroundView: DiscoverBackGround?
    var zoomingImageView: ZoomingImage?
    var iconsView : UIView?
    var downloadIconView : UIImageView?
    var addIconView : UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        // create a reference to the database
        dbRef = Database.database().reference().child("images")
        print(dbRef)
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
                newImages.insert(imageInstaObject, at: 0)
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
    
    
    
    var first = 0

    //Long Press when user clicks on an image from the grid layout
    @objc func handleLong(tapGesture: UILongPressGestureRecognizer) {
        
        switch tapGesture.state {
        case .began:
            first = Int(tapGesture.location(in: view).y)
            if let imageView = tapGesture.view as? UIImageView {
                performZoomInForStartingImageView(startingImageView: imageView)
                animateInfromGrid()
        }
        case .changed:
            let touch = tapGesture.location(in: view)
            guard first < (Int(touch.y) + 80) else{
                
                var action = SpotifyActionController.init()
                if let image = zoomingImageView?.image {
                    action = Helper().saveToFolder(image: image)
                }
                present(action, animated: true, completion: nil)
                
                return
            }
            
        case .ended:
            exitLongPress()
            animateOut()
        @unknown default: break
        }
        
    }
    
    
    
    
    func performZoomInForStartingImageView(startingImageView: UIImageView) {
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            
            
            //selecting the target image and converting it to a frame
            startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
            
            zoomingImageView = ZoomingImage(image: startingImageView.image!, frame: startingFrame!)
            zoomingImageView?.setupView(any: self, zoomOut: #selector(handleZoomOut), longPressed: #selector(longPressed))
            
            //swiping ability
            zoomingImageView?.swipe(target: self, action: #selector(handleZoomOut), direction: .up)
            zoomingImageView?.swipe(target: self, action: #selector(handleZoomOut), direction: .down)
            
            
            //creating black background
            blackBackgroundView = DiscoverBackGround(frame: keyWindow.frame)
            
            //All Gestures for blackBackground View
            blackBackgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
            blackBackgroundView?.swipe(target: self, action: #selector(handleZoomOut), direction: .up)
            blackBackgroundView?.swipe(target: self, action: #selector(handleZoomOut), direction: .down)
            
            
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
    
    
    //On the zoomed Image View
    @objc func longPressed(tapGesture: UILongPressGestureRecognizer) {
        guard tapGesture.state == .began else{
            return
        }
        animateIn()
        
    }

    
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        guard (longPressedBool == false) else {
            exitLongPress()
            longPressedBool = false
            return
        }
        
            if tapGesture.state == .ended {
                animateOut()
            }
    }
    
    
    func exitLongPress(){
        longPressedBool = false
        
        //        TODO reverse the animation back up
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                
                for item in keyWindow.layer.sublayers! {
                    switch item.name {
                        
                    case "icons_view":
                        self.exitIconsView()
                        
                    case "black_background":
                        self.exitBlackBackgroundView(item)
                        
                    case "zooming_image_view":
                        self.exitZoomingImageView(item, keyWindow)
                        
                    default:
                        print("defaulted: \(item.name ?? "No extra Layers")")
                    }
                }
            }) { (Bool) in
                //after completion
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    //EXTRA FUNCTIONS:
    
    
    
    
    
    
    
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
    
    
    //Turn iconsview invisible
    fileprivate func exitIconsView() {
        self.iconsView?.isHidden = true
    }
    
    
    //Resets the background color
    fileprivate func exitBlackBackgroundView(_ item: CALayer) {
        item.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0, 0, 0, 1.0])
    }
    
    //exits the zoomedImageFocus
    fileprivate func exitZoomingImageView(_ item: CALayer, _ keyWindow : UIWindow) {
        item.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: (self.zoomingImageView?.frame.height)! / 0.95)
        item.position = keyWindow.center
    }
    
    
    
    
    
    fileprivate func animateIn() {
        if let keyWindow = UIApplication.shared.keyWindow {
                
                //vibrate
                Helper().vibrate(style: .heavy)
                
                //change color of background
                blackBackgroundView?.backgroundColor = blackBackgroundView?.colorOnHold
                
                //Animate Inwards
                Helper().animateIn(iconsView: iconsView!, zoomingImageView: zoomingImageView!, keyWindow: keyWindow)
                
                longPressedBool = true
                return
            
        }
    }
    
    
    
    fileprivate func animateInfromGrid() {
        //if long press has not been pressed before
        if let keyWindow = UIApplication.shared.keyWindow {
            
              //vibrate
                Helper().vibrate(style: .heavy)
                
                //change color of background
                blackBackgroundView?.backgroundColor = blackBackgroundView?.colorOnHold
                
                //Animate Inwards
                Helper().animateIn(zoomingImageView: zoomingImageView!, keyWindow: keyWindow)
                
                longPressedBool = true
                return
        }
    }
    
    
    //animating the exit zoomedImageView
    func animateOut(){
        Helper().animateOut(zoomingImageView : zoomingImageView!, blackBackgroundView : blackBackgroundView!, startingFrame : startingFrame!)
    }
    
}
