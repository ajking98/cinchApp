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


class CameraViewController: UIViewController {
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var centerIndex = 0
    
    @IBOutlet weak var partition1: UIView!
    @IBOutlet weak var partition2: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainStage: UIView!
    @IBOutlet weak var fullscreen: UIImageView!
    @IBOutlet weak var multiple: UIImageView!
    @IBOutlet weak var circleCounter: UILabel!
    
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
    var isFullScreen = false
    var isMultipleSelected = false
    var isCollectionViewRaised = false
    
    var imageArray = [UIImage]()
    var selectedImages = [UIImage]()
    var tappedImages = [Int]() //holds the indexes of the tapped images
    
    
    func isAuthorized() ->Bool{
        var authStatus = false
        let photos = PHPhotoLibrary.authorizationStatus()
        if (photos == .authorized){
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
    
    override func viewDidAppear(_ animated: Bool) {
        let post = Post(isImage: false, postOwner: "James", link: "wwwfungamescom")
        ParentPostStruct().addPost(post: post)
        PostStruct().addTag(post: post.link!, newTag: "Games")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard isAuthorized() else{
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name : "Permissions", bundle: nil)
            let myviewController  :UIViewController = mainView.instantiateViewController(withIdentifier: "PermissionsView") as UIViewController
            self.present(myviewController, animated: true, completion: nil)
            return
        }
        
        buildShadow() //Builds the shadows for the icons (AddButton and swipe bar)
        buildSizes() //builds the sizes for the images in the scroll view
        buildPositioning()
        buildRadius() //Sets the radius for the imageViews (Needs to only be called once)
        buildLayout()
        buildGestures()
        
        grabPhotos()
        
        //Panning
        mainStage.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanCenterView(sender :)))
        
        mainStage.addGestureRecognizer(pan)
        
        
        imageCollectionViewFrame = imageCollectionView.frame
        solidBarFrame = solidBar.frame
        addButtonFrame = addButton.frame
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.isUserInteractionEnabled = true
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        centerView.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor)
        centerView.centerYAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerYAnchor)
        return self.centerView
    }
    
    
    func grabPhotos() {
        let imageManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .opportunistic
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        //setting the fetch limit(if this number is high, the app will run slower)
        fetchOptions.fetchLimit = 120
        
        if let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions) {
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count {
                    imageManager.requestImage(for: fetchResult.object(at: i) as! PHAsset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions) { (img, error) in
                        self.imageArray.append(img!)
                    
                        
                        //TODO do this for pagination:
//                        fetchResult.object(at: <#T##Int#>)
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
    
    func buildShadow(){
        //Setting the shadow for the views
        addShadow(selectedView: addButton)
        addShadow(selectedView: solidBar)
        partition1.layer.masksToBounds = false
        
        partition1.layer.shadowColor = UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1).cgColor
        partition1.layer.shadowOffset = CGSize(width: 0, height: 1)
        partition1.layer.shadowOpacity = 1.0
        partition1.layer.shouldRasterize = true
        partition1.layer.rasterizationScale = UIScreen.main.scale
    }
    
    
    func buildRadius(){
        //Creating the corner radius for left, right, and center views
        //centerView
        centerView.layer.cornerRadius = CGFloat(cornerRadius[0])
        
        //nextView
        nextView.layer.cornerRadius = CGFloat(cornerRadius[1])
        
        //previousView
        previousView.layer.cornerRadius = CGFloat(cornerRadius[1])
        
        //circleCounter
        circleCounter.layer.cornerRadius = circleCounter.frame.height / 2
        circleCounter.layer.borderColor = UIColor(red: 0.937, green: 0.937, blue: 0.957, alpha: 1).cgColor
        circleCounter.layer.borderWidth = 1.0
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
    
    func buildLayout(){
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 0
    }
    
    
    //Building all the gestures and enabling
    func buildGestures() {
        //adding user interactivity
        fullscreen.isUserInteractionEnabled = true
        multiple.isUserInteractionEnabled = true
        
        //taps
        addButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveToFolder)))
        
        fullscreen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFullScreenTapped)))
        
        multiple.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleTapped)))
        
        let doubleTapped = UITapGestureRecognizer(target: self, action: #selector(handleFullScreenTapped(_:)))
        doubleTapped.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapped)
        
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
    
    @objc func handleFullScreenTapped(_ sender : UITapGestureRecognizer? = nil) {
        if !isFullScreen {
            fullscreen.image = UIImage(named: "zoomIn")
            centerView.contentMode = .scaleAspectFill
        }
        else {
            fullscreen.image = UIImage(named: "fullscreen")
            centerView.contentMode = .scaleAspectFit
        }
        
        isFullScreen = !isFullScreen
    }
    
    @objc func handleMultipleTapped(_ sender : UITapGestureRecognizer? = nil) {
        if !isMultipleSelected {
            multiple.image = UIImage(named: "multipleSelected")
            circleCounter.isHidden = false
        }
        else {
            multiple.image = UIImage(named: "multiple")
            circleCounter.isHidden = true
            handleUndoTap()//undoes the borders for the tapped cells and clears the selectedImages array
            circleCounter.text = "0"
        }
        
        isMultipleSelected = !isMultipleSelected
    }
    
    
    @objc func handlePanCenterView(sender : UIPanGestureRecognizer) {
        unhideImages()
        guard let imageView = centerView else {
            return
        }
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began, .changed:
            let x = translation.x
            previousView.center.x += x
            imageView.center.x += x
            nextView.center.x += x
            
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
                buildPositioning()
            }
        default:
            print("Default")
        }
    }
    
    
    
    ///Animates the views to move to the previous image
    func animateScrollPrev(){
        
        guard self.centerIndex > 0 else {
            print("reached limit")
            buildPositioning()
            return
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.previousView.center.x = self.view.center.x
            self.centerView.center.x = (self.view.frame.width + self.scrollView.frame.width / 2) + 12
        })
        { (status) in
            
            if(self.centerIndex > 1){
                self.centerIndex -= 1
                self.change(self.imageArray[self.centerIndex - 1], self.imageArray[self.centerIndex], self.imageArray[self.centerIndex + 1])
            }
            else {
                self.centerIndex -= 1
                self.change(UIImage(named: "addImage")!, self.imageArray[self.centerIndex], self.imageArray[self.centerIndex + 1])
            }
            self.buildPositioning()
        }
    }
    
    ///Animates the views to move to the next image
    func animateScrollNext() {
        
        centerIndex += 1
        
        guard centerIndex < imageArray.count else{
            print("maxing out")
            buildPositioning()
            centerIndex -= 1
            return
            
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.nextView.center.x = self.view.center.x
            self.centerView.center.x = (0 - self.scrollView.frame.width / 2) - 12
        })
        { (status) in
            if(self.centerIndex < self.imageArray.count - 1){
                self.change(self.imageArray[self.centerIndex - 1], self.imageArray[self.centerIndex], self.imageArray[self.centerIndex + 1])
            }
            else {
                self.change(self.imageArray[self.centerIndex - 1], self.imageArray[self.centerIndex], UIImage(named: "addImage")!)
            }
            self.buildPositioning()
        }
    }
    
    func buildPositioning(){
        let frame = scrollView.frame
        let center = centerView.center
        //positioning - x
        centerView.center.x = scrollView.center.x
        previousView.center.x = (0 - frame.width / 2) - 32
        nextView.center.x = (view.frame.width + frame.width / 2) + 32
        
        // - y
        previousView.center.y = center.y
        nextView.center.y = center.y
        
        hideImages()
    }
    
    
    func buildSizes() {
        print("building the size")
        let frame = scrollView.frame
        
        //sizing
        previousView.frame.size = frame.size
        centerView.frame = frame
        nextView.frame.size = frame.size
        
        
        print("Previous frame: ", previousView.frame)
        print("currentView Frame:", centerView.frame)
        print("nextview freame", nextView.frame)
    }
    
    func unhideImages() {
        nextView.isHidden = false
        previousView.isHidden = false
    }
    
    func hideImages() {
        nextView.isHidden = true
        previousView.isHidden = true
    }
    
}
