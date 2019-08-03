//
//  CameraViewController.swift
//  InstagramClone
//
/*
 Prompted when user uploads image from camera roll and a delegate is used
 
 */


import UIKit
import CoreImage
import XLActionController
import Photos

class CameraViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var centerIndex = 0
    
    //Button and pullup bar
    @IBOutlet weak var addButton: UIImageView!
    @IBOutlet weak var solidBar: UIImageView!
    
    //previous, center, and next view
    @IBOutlet weak var centerView: UIImageView!
    
    @IBOutlet weak var nextView: UIImageView!
    
    @IBOutlet weak var previousView: UIImageView!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var FolderSliderView: UIView!
    @IBOutlet weak var prevFolderName: UILabel!
    @IBOutlet weak var currentFolderName: UILabel!
    @IBOutlet weak var nextFolderName: UILabel!
    
    
    //static values
    let cornerRadius = [6.0, 4.0, 5.0]
    var imageCollectionViewFrame : CGRect?
    var solidBarFrame : CGRect?
    var addButtonFrame : CGRect?
    
    
    //Dynamic values
    var isFullScreen = true
    
    var imageArray = [UIImage]()
    
    
    func isAuthorized() ->Bool{
        var authStatus = false
        let photos = PHPhotoLibrary.authorizationStatus()
        if (photos == .authorized){
            print("has already been pre-authorized")
            authStatus = true
        }
            
            //If Restricted by the user
        else if (photos == .restricted) {
            let alert = UIAlertController(title: "APP RESTRICTED", message: "you have restricted this app from accessing your photos", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
            //If denied or not determined, then ask
        else {
            authStatus = false
        }
        return authStatus
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard isAuthorized() else{
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name : "Permissions", bundle: nil)
            let myviewController  :UIViewController = mainView.instantiateViewController(withIdentifier: "PermissionsView") as UIViewController
            print("here is the view conroller ", mainView)
            self.present(myviewController, animated: true, completion: nil)
            return
        }
        
        buildShadow() //Builds the shadows for the icons (AddButton and swipe bar)
        buildSizes() //Also has the BuildBlur inside it (Must be called each time a new image is placed)
        buildRadius() //Sets the radius for the imageViews (Needs to only be called once)
        buildLayout()
        buildGestures()
        
        grabPhotos()
        
        //Panning
        centerView.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanCenterView(sender :)))
        centerView.addGestureRecognizer(pan)
        
        
        imageCollectionViewFrame = imageCollectionView.frame
        solidBarFrame = solidBar.frame
        addButtonFrame = addButton.frame
        
        let myTag = Tag(tagElement: TagElement(link: "hey"), tagLabel: "Emad2")
        ParentTagStruct().addTag(tag: myTag)
    }
    
    
    func grabPhotos() {
        let imageManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .opportunistic
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        
        if let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions) {
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count {
                    imageManager.requestImage(for: fetchResult.object(at: i) as! PHAsset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions) { (img, error) in
                        self.imageArray.append(img!)
                    }
                }
            }
        }
    }
    
    func change(_ imagePrev : UIImage, _ imageCurr : UIImage, _ imageNext : UIImage){
        changePreviousView(image: imagePrev)
        changeCenterView(image: imageCurr)
        changeNextView(image: imageNext)
        
        buildSizes()
    }
    
    func changeCenterView(image : UIImage){
        //Change the center view
        centerView.image = image
    }
    
    func changePreviousView(image: UIImage){
        //change the previous image view
        previousView.image = image
    }
    
    func changeNextView(image: UIImage){
        //change the next image view
        nextView.image = image
    }
    
    ///sizes all the image views accordingly with the image size
    func buildSizes(){
        if let image = centerView.image {
            centerView.frame.size = image.size
        }
        if let image = nextView.image {
            nextView.frame.size = image.size
        }
        if let image = previousView.image {
            previousView.frame.size = image.size
        }
    }
    
    func buildShadow(){
        //Setting the shadow for the views
        addShadow(selectedView: addButton)
        addShadow(selectedView: solidBar)
    }
    
    
    func buildRadius(){
        //Creating the corner radius for left, right, and center views
        //centerView
        centerView.layer.cornerRadius = CGFloat(cornerRadius[0])
        
        //nextView
        nextView.layer.cornerRadius = CGFloat(cornerRadius[1])
        
        //previousView
        previousView.layer.cornerRadius = CGFloat(cornerRadius[1])
    }
    
    
    
    func addShadow(selectedView : UIView){
        selectedView.layer.masksToBounds = false
        selectedView.layer.shadowColor = UIColor.black.cgColor
        
        selectedView.layer.shadowOpacity = 0.40
        selectedView.layer.shadowOffset = CGSize(width: 0, height: 3)
        selectedView.layer.shadowRadius = 5
        
        selectedView.layer.shouldRasterize = true
        selectedView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    
    func buildBlur(imageView : UIImageView){
        let blurEffect = UIBlurEffect(style: .prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        
        blurEffectView.frame = imageView.bounds
        imageView.addSubview(blurEffectView)
        
    }
    
    func buildLayout(){
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 0
        
        
        //        imageCollectionView.collectionViewLayout = layoutlayou
    }
    
    
    //Building all the gestures and enabling
    func buildGestures() {
        //taps
        solidBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSwipeUpAndSwipeDown)))
        addButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveToFolder)))
        
        //Panning
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender :)))
        imageCollectionView.addGestureRecognizer(pan)
        
        //segment Control
        segmentControl.addTarget(self, action: #selector(segmentControlValueChanged), for:.valueChanged)
        
        
        //enabling interactivity
        solidBar.isUserInteractionEnabled = true
        addButton.isUserInteractionEnabled = true
        imageCollectionView.isUserInteractionEnabled = true
    }
    
    
    @objc func handlePanCenterView(sender : UIPanGestureRecognizer) {
        let imageView = sender.view!
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began, .changed:
            
            let previousX = previousView.center.x + translation.x
            previousView.center.x = previousX
            
            let x = imageView.center.x + translation.x
            imageView.center.x = x
            
            let nextX = nextView.center.x + translation.x
            nextView.center.x = nextX
            
            sender.setTranslation(CGPoint.zero, in: view)
            
        case .ended:
            let centerX = view.center.x
            
            //swiping left
            if (imageView.center.x < centerX - 30) {
                animateScrollNext()
            }
                //swiping right
            else if(imageView.center.x > centerX + 30){
                animateScrollPrev()
            }
            else {
                imageView.center.x = centerX
            }
        default:
            print("Default")
        }
    }
    
    
    ///Animates the views to move to the previous image
    func animateScrollPrev(){
        UIView.animate(withDuration: 0.25, animations: {
            self.previousView.center.x = self.view.center.x
            self.centerView.frame.origin.x = self.view.frame.width
        }){ (status) in
            
            
            //todo come back to this next line for proper alignment when scrolling
            self.centerView.center.y = self.previousView.center.y
            
            
            if(self.centerIndex > 1){
                self.centerIndex -= 1
                self.change(self.imageArray[self.centerIndex - 1], self.imageArray[self.centerIndex], self.imageArray[self.centerIndex + 1])
            }
            else if(self.centerIndex == 1) {
                self.centerIndex -= 1
                self.change(UIImage(named: "addImage")!, self.imageArray[self.centerIndex], self.imageArray[self.centerIndex + 1])
            }
            self.centerView.center.x = self.view.center.x
            self.previousView.center.x = 0 - self.previousView.frame.width
            self.nextView.frame.origin.x = self.view.frame.width
        }
    }
    
    ///Animates the views to move to the next image
    func animateScrollNext() {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.nextView.center.x = self.view.center.x
            self.centerView.frame.origin.x = 0 - self.centerView.frame.width
        }){ (status) in
            if(self.centerIndex < self.imageArray.count - 2){
                self.centerIndex += 1
                self.change(self.imageArray[self.centerIndex - 1], self.imageArray[self.centerIndex], self.imageArray[self.centerIndex + 1])
            }
            else if(self.centerIndex < self.imageArray.count - 1) {
                self.centerIndex += 1
                self.change(self.imageArray[self.centerIndex - 1], self.imageArray[self.centerIndex], UIImage(named: "addImage")!)
            }
            self.centerView.center.x = self.view.center.x
            self.previousView.center.x = 0 - self.previousView.frame.width
            self.nextView.frame.origin.x = self.view.frame.width
        }
    }
    
    
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
                sender.setTranslation(CGPoint.zero, in: view)
            }
        case .ended:
            if(tableView.center.y < 750) {
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
    
    @objc func handleSwipeUpAndSwipeDown(){
        if isFullScreen {
            handleSwipeUp()
            isFullScreen = false
        }
            
        else {
            handleSwipeDown()
            isFullScreen = true
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
        Helper().vibrate(style: .medium)
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
        
        Helper().vibrate(style: .medium)
    }
    
    @objc func saveToFolder(_ tapGesture : UITapGestureRecognizer? = nil){
        if let image = centerView?.image {
            Helper().vibrate(style: .medium)
            let folderSelection = Helper().saveToFolder(image: image)
            present(folderSelection, animated: true, completion: nil)
        }
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
