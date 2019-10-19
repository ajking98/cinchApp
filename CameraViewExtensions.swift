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
    
    //TODO make the collectionView panable
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let gesture = scrollView.panGestureRecognizer
        let translation = gesture.translation(in: scrollView)
        let height = view.frame.height / 1.25
        
        if scrollView.center.y > height {
            followFingerVertical(view: scrollView, translation: translation)
            gesture.setTranslation(CGPoint.zero, in: scrollView)
        }
        
        if isAtTop{
            if translation.y > 0 && scrollView.center.y + translation.y < view.frame.height {
                followFingerVertical(view: scrollView, translation: translation) //pans the collectionview downwards
                gesture.setTranslation(CGPoint.zero, in: scrollView)
            }
        }
    }
    
    //Is triggered after the motion of the scroll stops
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let gesture = scrollView.panGestureRecognizer
        let translation = gesture.translation(in: scrollView)
        
    }
    
    //Is triggered whenever the scrollView is being moved for the first time
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("beginning")
    }
    
    //Is called when the user lifts their finger off the screen when scrolling
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("this is center:", scrollView.center)
        let gesture = scrollView.panGestureRecognizer
        let velocity = gesture.velocity(in: scrollView)
        var pullDownQuick = velocity.y > 820 ? true : false
        if velocity.y > 820 {
            handleSwipeDown()
            print("center1")
        }else if (velocity.y < -820){
            handleSwipeUp()
            print("center2")
        }
        else {
            if scrollView.center.y > view.frame.height - 20 {
                handleSwipeDown()
                print("center3")
            }else{
                handleSwipeUp()
                print("center4")
            }
        }
    }
    
    
//    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
//        print("this is the scrolled")
//    }
    
    //checks if the collectionView is at the top
    var isAtTop : Bool {
        return imageCollectionView.contentOffset.y < -60
    }
    
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
    
    
    
    //TODO handles the panning of the collectionView
    @objc func handlePan(sender : UIPanGestureRecognizer) {
        let tableView = sender.view!
        let translation = sender.translation(in: view)
        
        let collectionViewY = translation.y + imageCollectionView.frame.origin.y
        if ((isCollectionViewRaised) && (collectionViewY < (imageCollectionViewFrame?.origin.y)! - 450)) {
            //TODO
//            imageCollectionView.contentOffset.y -= translation.y * 0.4
//            sender.setTranslation(CGPoint.zero, in: view)
            return
        }
        
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
                    handleSwipeUp()
                }
                else {
                    handleSwipeDown()
                }
            }
            else if(tableView.center.y < 750) {
                handleSwipeUp()
            }
            else {
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
        isCollectionViewRaised = true
        Helper().vibrate(style: .light)
    }
    
    @objc func handleSwipeDown(_ tapGesture  :UITapGestureRecognizer? = nil){
        UIView.animate(withDuration: 0.2) {
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
        isCollectionViewRaised = false
        Helper().vibrate(style: .light)
    }
    
    //this creates the folder selector popup view and the tagging input box
    @objc func saveToFolder(_ tapGesture : UITapGestureRecognizer? = nil){
        guard selectedImages.count != 0 else {// if the size of the selectedimages array is empty, then vibrate heavy
            Helper().vibrate(style: .heavy)
            return
            
        }
        if selectedImages.count == 1 {
            let image = selectedImages[0]
            Helper().vibrate(style: .light)
            let folderSelection = Helper().saveToFolder(image: image, viewController: self)
            present(folderSelection, animated: true, completion: nil)
        }
        
        else {
            let action = Helper().saveMultipleImages(images: selectedImages)
            present(action, animated: true, completion: {
                self.handleUndoTap()
            })
        }
        
    }
    
    
    
    
    @objc func handleCellTapped(tapGesture : UITapGestureRecognizer) {
        if (tapGesture.view is CameraViewCell) {
            let cell = tapGesture.view as! CameraViewCell
            print(cell.currentIndex, "is the current index")
            centerIndex = cell.currentIndex
            
            guard let image = cell.imageView.image else { return }
            centerView.image = image
            
            if (cell.currentIndex < (imageArray.count - 1)){
                nextView.image = imageArray[cell.currentIndex + 1]
            }
            
            if cell.currentIndex > 0 {
                previousView.image = imageArray[cell.currentIndex - 1]
            }
            
            
            //handles the border of the tapped image(s)
            if !isMultipleSelected {
                handleUndoTap()
            }
            if cell.isTapped {
                handleUndoTapSingle(index: cell.currentIndex)
            }
            else{
                cell.layer.borderWidth = 3
                cell.layer.borderColor = UIColor.selected.cgColor
                tappedImages.append(cell.currentIndex)
                selectedImages.append(cell.imageView.image!)
                circleCounter.text = String(tappedImages.count)
                cell.isTapped = true
            }
        }
    }
    
    //TODO this should update the selectedImages and tappedImages array along with the circle counter
    ///undoes the border for a single cell
    func handleUndoTapSingle(index : Int){
        let indexPath = IndexPath(item: index, section: 0)
        let cell = imageCollectionView.cellForItem(at: indexPath) as! CameraViewCell
        cell.layer.borderWidth = 0
        cell.isTapped = false
        
        //Using the cell's current index to remove the image from both arrays
        for x in 0..<tappedImages.count {
            if tappedImages[x] == index{
                tappedImages.remove(at: x)
                selectedImages.remove(at: x)
                circleCounter.text = String(tappedImages.count)
                break
            }
        }
    }
    
    
    ///Cycles through the tappedImages array and undoes the border hightlight for each cell
    func handleUndoTap() {
        for index in tappedImages{
            let indexPath = IndexPath(item: index, section: 0)
            let cell = imageCollectionView.cellForItem(at: indexPath) as! CameraViewCell
            cell.layer.borderWidth = 0
            cell.isTapped = false
        }
        tappedImages = []
        selectedImages = []
        circleCounter.text = "0"
    }
}
