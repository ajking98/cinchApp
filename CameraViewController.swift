//
//  CameraViewController.swift
//  Cinch
//
/*
 Prompted when user uploads image from camera roll and a delegate is used
 
 */


import UIKit
import CoreImage
import XLActionController
import Photos
import AVKit


class CameraViewController: UIViewController {
    
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
    
    
    //static values
    let cornerRadius = [6.0, 4.0, 5.0]
    var imageCollectionViewFrame : CGRect?
    var solidBarFrame : CGRect?
    var addButtonFrame : CGRect?
    
    var fetchResult : PHFetchResult<PHAsset>?
    let imageManager = PHImageManager.default()
    let requestOptions = PHImageRequestOptions()
    
    //Dynamic values
    var isFullScreen = false
    var isMultipleSelected = false
    var isCollectionViewRaised = false
    
    var contentArray = [NSObject]()
    var selectedContent = [NSObject]() //holds both images and videos that have been selected
    var selectedIndexes = [Int]() //holds the indexes of the tapped images (Maybe change it so that it holds the index path?)
    
    
    var isAtTop = false //holds the value on whether or not the scroll for the imagecollectionview is a the top
    var globalContentOffset : CGFloat = 0
    var isFollowingGesture = false
    var isContentOffsetZero = false
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isAuthorized(){
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name : "Permissions", bundle: nil)
            let vc = mainView.instantiateViewController(withIdentifier: "PermissionsView") as! PermissionsController
            vc.render = setUp
            self.present(vc, animated: true, completion: nil)
        }
        else {
            setUp()
        }
    }
    
    
    func setUp() {
        buildShadow() //Builds the shadows for the icons (AddButton and swipe bar)
        buildSizes() //builds the sizes for the images in the scroll view
        buildPositioning()
        buildRadius() //Sets the radius for the imageViews (Needs to only be called once)
        buildLayout()
        buildGestures()
        globalContentOffset = imageCollectionView.contentOffset.y
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
        fullscreen.image = UIImage(named: "zoomIn")
        centerView.contentMode = .scaleAspectFill
        centerView.center = scrollView.center
        return self.centerView
    }
    
    
    func grabPhotos() {
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .opportunistic

        let fetchOptions = PHFetchOptions()
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        //setting the fetch limit(if this number is high, the app will run slower)
        fetchOptions.fetchLimit = 120
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        if let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: fetchOptions) {
            if fetchResult.count > 0 {
                
                self.fetchResult = fetchResult
//                for i in 0..<fetchResult.count {
//                    switch fetchResult.object(at: i).mediaType {
//                    case .image:
//                        print("one image")
//                    case .video:
//                    print("one video")
//
//                    default:
//                        print("this is something else")
//                    }
////                    imageManager.requestPlayerItem(forVideo: fetchResult.object(at: i), options: requestOptions) { (playerItem, error) in
////                        print("something")
////                    }
//                }
                
                imageCollectionView.reloadData()
                if contentArray.count > 2 {
                    //TODO this should first check if the first two objects are images then does the code below. If they are not images, then it should present them as videos
                    centerView.image = contentArray[0] as? UIImage
                    nextView.image = contentArray[1] as? UIImage
                }
            }
        }
        
    }
    
    
    ///Adds an AVPlayer to a UIView
    private func addPlayer(selectedView: UIView, playerItem: AVPlayerItem, _ isMuted: Bool = true) {
        if let url = (playerItem.asset as? AVURLAsset)?.url {
            clearView(selectedView: selectedView)
            let player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resize
            selectedView.layer.addSublayer(playerLayer)
            playerLayer.frame = selectedView.bounds
            player.play()
            player.isMuted = isMuted
        }
    }
    
    
    
    ///Changes all three views to using the center index
    func change(centerIndexPath: IndexPath){
        changeCenterView(indexPath: centerIndexPath)
        
        let prevIndexPath = IndexPath(item: centerIndexPath.item - 1, section: 0)
        changePreviousView(indexPath: prevIndexPath)
        
        let nextIndexPath = IndexPath(item: centerIndexPath.item + 1, section: 0)
        changeNextView(indexPath: nextIndexPath)
         
        buildSizes()
    }
    
    ///Changes the content of the center View to the object given
    func changeCenterView(indexPath : IndexPath){
        guard let cellContent = fetchResult?.object(at: indexPath.item) else { return }
        
        switch cellContent.mediaType {
        case .image:
            imageManager.requestImage(for: cellContent, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions) { (img, error) in
                if let image = img {
                    self.clearView(selectedView: self.centerView)
                    self.centerView.image = image
                }
            }
        case .video:
            imageManager.requestPlayerItem(forVideo: cellContent, options: nil) { (playerItem, error) in
                if let playerItem = playerItem {
                    self.addPlayer(selectedView: self.centerView, playerItem: playerItem, false)
                }
            }
        default:
            print("default")
        }
    }
    
    ///Changes content of the previous view to the object given
    func changePreviousView(indexPath : IndexPath){
        guard indexPath.item >= 0 else { return }
        guard let cellContent = fetchResult?.object(at: indexPath.item) else { return }

        switch cellContent.mediaType {
        case .image:
            imageManager.requestImage(for: cellContent, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions) { (img, error) in
                if let image = img {
                    self.clearView(selectedView: self.previousView)
                    self.previousView.image = image
                }
            }
        case .video:
            imageManager.requestPlayerItem(forVideo: cellContent, options: nil) { (playerItem, error) in
                if let playerItem = playerItem {
                    self.addPlayer(selectedView: self.previousView, playerItem: playerItem)
                }
            }
        default:
            print("default")
        }
    }
    
    ///Changes the content of the next view to the object given
    func changeNextView(indexPath: IndexPath){
        guard indexPath.item < fetchResult!.count else { return }
        guard let cellContent = fetchResult?.object(at: indexPath.item) else { return }
        
        switch cellContent.mediaType {
        case .image:
            imageManager.requestImage(for: cellContent, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions) { (img, error) in
                if let image = img {
                    self.clearView(selectedView: self.nextView)
                    self.nextView.image = image
                }
            }
        case .video:
            imageManager.requestPlayerItem(forVideo: cellContent, options: nil) { (playerItem, error) in
                if let playerItem = playerItem {
                    self.addPlayer(selectedView: self.nextView, playerItem: playerItem)
                }
            }
        default:
            print("default")
        }
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
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 0
        
        addButton.tintColor = .lightGreen
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
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender :)))
//        imageCollectionView.addGestureRecognizer(pan)
        
        
        //enabling interactivity
        solidBar.isUserInteractionEnabled = true
        addButton.isUserInteractionEnabled = true
        imageCollectionView.isUserInteractionEnabled = true
        
        solidBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:))))
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
            self.centerIndex -= 1
            self.change(centerIndexPath: IndexPath(item: self.centerIndex, section: 0))
            self.buildPositioning()
        }
    }
    
    ///Animates the views to move to the next image
    func animateScrollNext() {
        
        centerIndex += 1
        
        guard centerIndex < fetchResult!.count else{
            buildPositioning()
            centerIndex -= 1
            return
            
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.nextView.center.x = self.view.center.x
            self.centerView.center.x = (0 - self.scrollView.frame.width / 2) - 12
        })
        { (status) in
            self.change(centerIndexPath: IndexPath(item: self.centerIndex, section: 0))
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
    
    ///Removes all the sublayers for the given UIView
    func clearView(selectedView: UIView) {
        selectedView.layer.sublayers?.forEach({ (layer) in
            layer.removeFromSuperlayer()
        })
    }
    
}
