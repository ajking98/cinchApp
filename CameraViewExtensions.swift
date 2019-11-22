//
//  CameraViewExtensions.swift
//  Cinch
//
//  Created by Ahmed Gedi on 8/4/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit


//Collection View
extension CameraViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Checks if the scrollview that is being called is a collectionView
        guard let scrollView = scrollView as? UICollectionView else { return }
        
//        print("disabling the scroll", imageCollectionView.frame, " and this the ther ogther", scrollView.panGestureRecognizer.location(in: view))
        //If pangesture location.y < imageCollectionView.frame.origin.y then the imageCollectionView.y should follow the gesture
        let gesture = scrollView.panGestureRecognizer
        let translation = gesture.translation(in: view)
        let height = view.frame.height * 0.65
        let height2 = view.frame.height * 1.15
        
        
        if gesture.location(in: view).y < scrollView.frame.origin.y {
            isFollowingGesture = true
        }
        
        
        
        
        if isFollowingGesture {
            guard scrollView.center.y > height else { return }
            guard scrollView.center.y < height2 else { return }
            scrollView.contentOffset.y = globalContentOffset
            scrollView.frame.origin.y = gesture.location(in: view).y
            solidBar.center.y = scrollView.frame.origin.y - 10
            gesture.setTranslation(CGPoint.zero, in: scrollView)
        }
        else if isContentOffsetZero && isAtTop {
            print("we at top")
            if translation.y > 0 && scrollView.center.y + translation.y < view.frame.height {
                scrollView.contentOffset.y = globalContentOffset
                scrollView.center.y += translation.y * 0.5 //pans the collectionview downwards
                solidBar.center.y = scrollView.frame.origin.y - 10
                gesture.setTranslation(CGPoint.zero, in: scrollView)
            }
        }
        else {
            globalContentOffset = scrollView.contentOffset.y
        }
    }
    
    //Is triggered after the motion of the scroll stops
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let scrollView = scrollView as? UICollectionView else { return }
        handleGestureEnded(scrollView: scrollView)
    }
    
    //Is triggered whenever the scrollView is being moved for the first time
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let scrollView = scrollView as? UICollectionView else { return }
        isContentOffsetZero = abs(scrollView.contentOffset.y) < 2
        print("beginning")
    }
    
    //Is called when the user lifts their finger off the screen when scrolling
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let scrollView = scrollView as? UICollectionView else { return }
        handleGestureEnded(scrollView: scrollView)
    }
    
    func handleGestureEnded(scrollView : UIScrollView) {
        guard let scrollView = scrollView as? UICollectionView else { return }
        isFollowingGesture = false
        isAtTop = scrollView.frame.origin.y < view.frame.height * 0.5
        
        let gesture = scrollView.panGestureRecognizer
        let velocity = gesture.velocity(in: scrollView)
        if velocity.y > 820 && isContentOffsetZero {
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CameraViewCell
        handleCellSelected(cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CameraViewCell
        cell.imageView.image = imageArray[indexPath.row]
        cell.currentIndex = indexPath.row
        cell.imageView.contentMode = UIView.ContentMode.scaleAspectFill
        
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
    
    
    @objc func handleSwipeUp(_ tapGesture : UITapGestureRecognizer? = nil){
        print("we are moving upward")
        //perform animation to swipe the collection view upward
        UIView.animate(withDuration: 0.3) {
            guard let tempFrame = self.imageCollectionViewFrame else{
                return
            }
            let originX = tempFrame.origin.x
            let originY = tempFrame.origin.y
            
            
            //Updated values
            let updatedOriginY = originY - 420
            
            self.imageCollectionView.frame.origin = CGPoint(x: originX, y: updatedOriginY)
            
            self.solidBar.frame.origin.y = (updatedOriginY - 24)
        }
        isCollectionViewRaised = true
//        Helper().vibrate(style: .light)
    }
    
    @objc func handleSwipeDown(_ tapGesture  :UITapGestureRecognizer? = nil){
        print("are we swiping down now?")
        UIView.animate(withDuration: 0.2) {
            self.imageCollectionView.frame = self.imageCollectionViewFrame!
            self.solidBar.frame = self.solidBarFrame!
            self.addButton.frame = self.addButtonFrame!
        }
        isCollectionViewRaised = false
//        Helper().vibrate(style: .light)
    }
    
    //this creates the folder selector popup view and the tagging input box
    @objc func saveToFolder(_ tapGesture : UITapGestureRecognizer? = nil){
        // if the selectedimages array is empty, then vibrate heavy
        guard selectedImages.count != 0 else {
            return
            
        }
        Helper().vibrate(style: .light)
        //if the selected images array has a single value, then present folderselection
        if selectedImages.count == 1 {
            let image = selectedImages[0]
            Helper().vibrate(style: .light)
            Helper().saveToFolder(image: image, viewController: self)
        }
        
        else {
            Helper().saveMultipleImages(images: selectedImages, viewController: self)
            self.handleUndoTap()
            self.handleMultipleTapped()
        }
        
    }
    
    //handles the border and insertion into the arrays
    ///Handles the functionality for when a cell is selected from the collectionview
    func handleCellSelected(_ cell : CameraViewCell) {
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
            cell.handleTap()
            tappedImages.append(cell.currentIndex)
            selectedImages.append(cell.imageView.image!)
            circleCounter.text = String(tappedImages.count)
        }
    }
    
    //This isn't being called for some reason
    //updates the selectedImages and tappedImages array along with the circle counter
    ///undoes the border for a single cell
    func handleUndoTapSingle(index : Int){
        print("doing the single tapp")
        let indexPath = IndexPath(item: index, section: 0)
        let cell = imageCollectionView.cellForItem(at: indexPath) as! CameraViewCell
        cell.undoTap()
        
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
        print("we are undoing", imageCollectionView.indexPathsForSelectedItems)
        for index in tappedImages{
            let indexPath = IndexPath(item: index, section: 0)
            if imageCollectionView.indexPathsForVisibleItems.contains(indexPath) {
                let cell = imageCollectionView.cellForItem(at: indexPath) as! CameraViewCell
                cell.undoTap()
            }
        }
        tappedImages = []
        selectedImages = []
        circleCounter.text = "0"
    }
}
