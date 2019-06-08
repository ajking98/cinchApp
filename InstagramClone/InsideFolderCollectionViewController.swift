//
//  InsideFolderCollectionViewController.swift
//  inside the folder
/*
        1. the user should be able to swipe to the next and previous folder from the inside
        2. User should be able to tap the wallpaper image and replace it with another image
        3. The user should be able to tap an image and be able to download it (recieve same treatment as the discover page)
        4. Pressing the green ADD button should trigger the camera view
        5. Button should have shadow
        6. User should be able to press and hold to move image order around inside of folder 
 
 */
//
//  Created by Gedi, Ahmed M on 4/14/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import FirebaseDatabase

class InsideFolderCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let plus = UIImage(named: "plus")

    @IBOutlet var imageCollection: UICollectionView!
    var customImageFlowLayout: CustomImageFlowLayout!
    var dbRef: DatabaseReference!
    var images = [ImageInsta]()
    let imagePicker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        // create a reference to the database
        dbRef = Database.database().reference().child("uncategorized/folderImages")
        loadDB()
        
        customImageFlowLayout = CustomImageFlowLayout()
        imageCollection.collectionViewLayout = customImageFlowLayout
        imageCollection.backgroundColor = .white
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    
    
    //creating the Add image icon
    override func viewDidAppear(_ animated: Bool) {
        
        //getting screen dimensions
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
            
            print("Inside folder view")
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FolderCollectionViewCell
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
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = .black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView!)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                self.zoomingImageView?.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                self.zoomingImageView?.center = keyWindow.center
            }, completion: nil)
        }
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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    
    
    //Swiping folder from inside the folder
    
    //Swipe to the RIGHT from the left side
    @objc func handleRightSwipe(gesture: UIGestureRecognizer){
        print("you swiped right")
    }
    
    //Swipe to the LEFT from the right side
    @objc func handleLeftSwipe(gesture: UIGestureRecognizer){
        print("You swiped left")
    }


}
