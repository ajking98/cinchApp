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
    var userImages = ["n3", "n2", "n1","n3", "n2", "n1","n3", "n2", "n1","n3", "n2", "n1"]
    var isFullScreen = true
    
    
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


        imageCollectionViewFrame = imageCollectionView.frame
        solidBarFrame = solidBar.frame
        addButtonFrame = addButton.frame
        
        let myTag = Tag(tagElement: TagElement(link: "hey"), tagLabel: "Emad2")
        ParentTagStruct().addTag(tag: myTag)
    }
    
    func change(imagePrev : UIImage, imageCurr : UIImage, imageNext : UIImage){
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
            if(tableView.center.y < 850) {
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
        
        userImages.append("n4")
        return userImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CameraViewCell
        cell.imageView.image = UIImage(named: userImages[indexPath.row])
        cell.imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return cell
    }
}
