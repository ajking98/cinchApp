//
//  CameraViewExtensions.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 8/4/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit


//Collection View
extension CameraViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CameraViewCell
        cell.imageView.image = imageArray[indexPath.row]
        cell.currentIndex = indexPath.row
        cell.imageView.contentMode = UIView.ContentMode.scaleAspectFill
        
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCellTapped)))
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 4 - 5
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}







//Event handlers
extension CameraViewController {
    
    @objc func handlePan(sender : UIPanGestureRecognizer) {
        let tableView = sender.view!
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began, .changed:
            let y = tableView.center.y + translation.y
            if (Int(y) > 600 && Int(y) < 1040) {
                tableView.center.y = y
                
                let updatedY = tableView.frame.origin.y - FolderSliderView.frame.height/2
                FolderSliderView.center.y = updatedY
                
                solidBar.center.y = updatedY - 30
                //TODO fix this part
                sender.setTranslation(CGPoint.zero, in: view)
            }
        case .ended:
            if(isQuickSwipe(velocity: sender.velocity(in: view).y)){
                if(sender.velocity(in: view).y < 0){
                    print("swiping upwards")
                    handleSwipeUp()
                }
                else {
                    print("downward")
                    handleSwipeDown()
                }
            }
            else if(tableView.center.y < 750) {
                print("fullscreening")
                handleSwipeUp()
            }
            else {
                print("snapping back to bottom")
                handleSwipeDown()
            }
        case .possible, .cancelled, .failed:
            print("finish later")
        @unknown default:
            print("finishing later")
        }
    }
    
    
    @objc func segmentControlValueChanged(segment : UISegmentedControl){
        if segment.selectedSegmentIndex == 0 {
            handleSwipeDown()
        }
    }
    
    
    @objc func handleSwipeUp(_ tapGesture : UITapGestureRecognizer? = nil){
        //perform animation to swipe the collection view upward
        print("working")
        UIView.animate(withDuration: 0.4) {
            guard let tempFrame = self.imageCollectionViewFrame else{
                return
            }
            let originX = tempFrame.origin.x
            let originY = tempFrame.origin.y
            let heightFS : CGFloat = 30.0
            
            
            //Updated values
            let updatedOriginY = originY - 420
            
            self.imageCollectionView.frame.origin = CGPoint(x: originX, y: updatedOriginY)
            
            self.solidBar.frame.origin.y = (updatedOriginY - 24) - heightFS
            self.FolderSliderView.frame.origin.y = updatedOriginY - heightFS
            
            self.FolderSliderView.frame.size.height = heightFS
            self.prevFolderName.frame.size.height = heightFS
            self.currentFolderName.frame.size.height = heightFS
            self.nextFolderName.frame.size.height = heightFS
        }
        Helper().vibrate(style: .light)
    }
    
    @objc func handleSwipeDown(_ tapGesture  :UITapGestureRecognizer? = nil){
        UIView.animate(withDuration: 0.2) {
            print("swiping")
            self.imageCollectionView.frame = self.imageCollectionViewFrame!
            self.solidBar.frame = self.solidBarFrame!
            self.addButton.frame = self.addButtonFrame!
            
            let heightFS : CGFloat = 0
            
            self.FolderSliderView.frame.origin.y = self.imageCollectionViewFrame!.origin.y
            self.FolderSliderView.frame.size.height = heightFS
            self.prevFolderName.frame.size.height = heightFS
            self.currentFolderName.frame.size.height = heightFS
            self.nextFolderName.frame.size.height = heightFS
        }
        
        Helper().vibrate(style: .light)
    }
    
    @objc func saveToFolder(_ tapGesture : UITapGestureRecognizer? = nil){
        
        let alert = UIAlertController(title: "Tags", message: "Tag this gem to find it later", preferredStyle: .alert)
        alert.addTextField { (textField) in
            
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Finish", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
        if let image = centerView?.image {
            Helper().vibrate(style: .medium)
            let folderSelection = Helper().saveToFolder(image: image)
            present(folderSelection, animated: true, completion: nil)
        }
        
    }
    
    
    
    
    @objc func handleCellTapped(tapGesture : UITapGestureRecognizer) {
        if (tapGesture.view is CameraViewCell) {
            let cell = tapGesture.view as! CameraViewCell
            print(cell.currentIndex, "is the current index")
            centerIndex = cell.currentIndex
            
            centerView.image = cell.imageView.image
            if (cell.currentIndex < (imageArray.count - 1)){
                nextView.image = imageArray[cell.currentIndex + 1]
            }
            
            if cell.currentIndex > 0 {
                previousView.image = imageArray[cell.currentIndex - 1]
            }
        }
    }
}
