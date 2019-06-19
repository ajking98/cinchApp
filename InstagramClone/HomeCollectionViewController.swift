//
//  HomeCollectionViewController.swift
//  Discover Page
//
//  Created by Gedi, Ahmed M on 4/14/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SDWebImage
import Photos
import XLActionController
import SQLite


class HomeCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func goToCamera(_ sender: Any) {
        tabBarController?.selectedIndex = 1
    }
    @IBOutlet var imageCollection: UICollectionView!
    var customImageFlowLayout: CustomImageFlowLayout!
    var dbRef: DatabaseReference!
    let uuid = UIDevice.current.identifierForVendor!
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
    
    var database: Connection!
    var randomUniqueId: String?
    let usersTable = Table("users")
    let id = Expression<Int>("id")
    let name = Expression<String?>("name")
    let email = Expression<String?>("email")
    let password = Expression<String?>("password")
    let isPrivate = Expression<Bool?>("isPrivate")
    //    let profilePic = Expression<String?>("profilePic")
    //    let dateCreated = Expression<String?>("dateCreated")
    //    let dateLastActive = Expression<String?>("dateLastActive")
    //    let folder = Expression<[String]?>("folders")
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        deleteUserFromDefault(key: defaultsKeys.usernameKey)
        let status = userDefaults.string(forKey: defaultsKeys.usernameKey) ?? ""
        if status == "" {
            print("Hey")
            let uniqueUsername = randomUniqueId(length: 10)
            // TODO Create Function for checking for duplicates
//            checkUserForDuplicates(uniqueUsername)
            userDefaults.set(uniqueUsername, forKey: defaultsKeys.usernameKey)
            let newUser = User(username: uniqueUsername)
            ParentStruct().createUser(user: newUser)

            ParentStruct().readUser(user: newUser.username!, completion: { (userInfo:User, dateCreated:String, dateLastActive:String, folders:Any) in
                UserStruct().readFolders(user: newUser.username!, readFolderClosure: {(folders:[String]) in
                    // Get User's Info
                    self.userDefaults.set(folders, forKey: defaultsKeys.folderKey)
                    self.userDefaults.set(userInfo.name!, forKey: defaultsKeys.nameKey)
                    self.userDefaults.set(userInfo.email!, forKey: defaultsKeys.emailKey)
                    self.userDefaults.set(userInfo.password!, forKey: defaultsKeys.passwordKey)
                    self.userDefaults.set(userInfo.isPrivate, forKey: defaultsKeys.isPrivateKey)
                    self.userDefaults.set(dateCreated, forKey: defaultsKeys.dateCreatedKey)
                    self.userDefaults.set(dateLastActive, forKey: defaultsKeys.dateLastActiveKey)
                })
            })
        }
        UserStruct().deleteFolder(user: status, folderName: "Songs")
//        var tempUser = User(username: "FartMeister")
//        ParentStruct().createUser(user: tempUser)
//        ParentStruct().updateUser(oldUsername: "FartMeister", newUsername: "Grand Solomon", prevUserInfo: tempUser)
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        
//        print(userDefaults.string(forKey: defaultsKeys.folderKey)!)
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
        
        //Swipe left 
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(openCameraView))
        swipe.direction = .left
        view.addGestureRecognizer(swipe)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func deleteUserFromDefault(key:String) -> Bool {
        var keyValue = UserDefaults.standard.object(forKey: key)
        UserDefaults.standard.removeObject(forKey:key)
        return true
    }
    
    func randomUniqueId(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = "-%&%-"
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    // Creates Table
    func createTable() {
        print("Create Table")
        
        let createTable = self.usersTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.name)
            table.column(self.email)
            table.column(self.password)
            table.column(self.isPrivate)
            //            table.column(self.profilePic)
            //            table.column(self.dateCreated)
            //            table.column(self.dateLastActive)
        }
        
        do {
            try self.database.run(createTable)
            print("Created Table")
        } catch {
            print(error)
        }
        
    }
    
    func insertUser() {
        print("Insert User")
        ParentStruct().readUser(user: uuid.uuidString, completion: { (userInfo:User, dateCreated:String, dateLastActive:String, folders:Any) in
            print("printing userhh: ", userInfo)
            print("printing name: ", userInfo.name!)
            print("printing password: ", userInfo.password!)
            let insertUser = self.usersTable.insert(self.name <- userInfo.name!, self.email <- userInfo.email!, self.password <- userInfo.password!, self.isPrivate <- userInfo.isPrivate! )
            
            do {
                try self.database.run(insertUser)
                print("Inserted User ")
            } catch {
                print(error)
            }
        })
        
        
    }
    
    
    func listUsers() {
        print("List Users")
        do {
            let users = try self.database.prepare(usersTable)
            for user in users {
                print("userID: \(user[self.id]), name: \(String(describing: user[self.name]!)), email: \(String(describing: user[self.email]!)), password: \(String(describing: user[self.password]!)), isPrivate: \(String(describing: user[self.isPrivate]!))" )
            }
        } catch {
            print(error)
        }
    }
    
    func updateUser(_ sender: Any) {
        print("Update User")
        let alert = UIAlertController(title: "Update User", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "User ID" }
        alert.addTextField { (tf) in tf.placeholder = "Email" }
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let userIdString = alert.textFields?.first?.text,
                let userId = Int(userIdString),
                let email = alert.textFields?.last?.text
                else { return }
            print(userIdString)
            print(email)
            
            let user = self.usersTable.filter(self.id == userId)
            let updateUser = user.update(self.email <- email)
            do {
                try self.database.run(updateUser)
            } catch {
                print(error)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func deleteUser(userId:Int) {
        print("Delete User")
        let user = self.usersTable.filter(self.id == userId)
        let deleteUser = user.delete()
        do {
            try self.database.run(deleteUser)
        } catch {
            print(error)
        }
    }
    
    func getUserInfo() {
        if let stringOne = self.userDefaults.string(forKey: defaultsKeys.nameKey) {
            print(stringOne) // Some String Value
        }
        
        if let stringTwo = self.userDefaults.string(forKey: defaultsKeys.emailKey) {
            print(stringTwo) // Some String Value
        }
        if let stringThree = self.userDefaults.string(forKey: defaultsKeys.passwordKey) {
            print(stringThree) // Some String Value
        }
        if let stringFour = self.userDefaults.string(forKey: defaultsKeys.isPrivateKey) {
            print(stringFour) // Some String Value
        }
        if let stringFive = self.userDefaults.string(forKey: defaultsKeys.dateCreatedKey) {
            print(stringFive) // Some String Value
        }
        if let stringSix = self.userDefaults.string(forKey: defaultsKeys.dateLastActiveKey) {
            print(stringSix) // Some String Value
        }
        
        let foodArray = self.userDefaults.object(forKey: defaultsKeys.folderKey) as? [String] ?? [String]()
        print(foodArray.count)
        print(foodArray[0])
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
            zoomingImageView?.swipe(target: self, action: #selector(handleNextImage), direction: .left)
            zoomingImageView?.swipe(target: self, action: #selector(handlePrevImage), direction: .right)
            
            
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
    
    @objc func openCameraView(){
        self.tabBarController?.selectedIndex = 1
    }
    
    @objc func handleNextImage(){
        print("set up next Image")
    }
    
    @objc func handlePrevImage() {
        print("set up previous image")
    }
    
}
