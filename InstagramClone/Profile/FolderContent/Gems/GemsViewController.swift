//
//  GemsViewController.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 6/23/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.

import UIKit
import Cards
import FirebaseStorage
import FirebaseDatabase

class GemsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var dbRef: DatabaseReference!
    var folderNames: [String]?
    
    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier = "GemCell"
    
    //TODO THESE should hold actual folder objects
    var folders : [Folder] = []
    
    var objectNames = ["Dogs"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        setupCollectionViewLayout()
    }
    
    
    ///Is called to pull the latest changes done to a folder
    func updateLocalFolders() {
        let username = String(UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!)
        UserStruct().readCompleteFolders(user: username) { (folderList) in
            self.folders = folderList
        }
    }
    
    
    //Sets up the Viewcontroller for when the folder is tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FolderCotent") as! FolderContent
        
        vc.folderName = folders[indexPath.row].folderName
        vc.contentCount = folders[indexPath.row].content.count
        
        present(vc, animated: true, completion: nil)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //setting the folders to the value from the user defaults
        //user defaults was set in the AppDelegate when the app is first run
        if UserDefaults.standard.object(forKey: defaultsKeys.numberOfFolders) != nil {
            objectNames = UserDefaults.standard.object(forKey: defaultsKeys.numberOfFolders) as! [String]
        }
        
        let username = String(UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!)
        //reading the complete folder from the database
        UserStruct().readCompleteFolders(user: username) { (folderList) in
            self.folders = folderList
        }
        return objectNames.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row + 1 < objectNames.count + 1{
            print(indexPath.row)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GemsCollectionViewCell
            designCell(cell: cell)
            
            let username = String(UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!)
            FolderStruct().readIcon(user: username, folderName: objectNames[indexPath.row]) { (link) in
                let folder = self.objectNames[indexPath.row]
                let url = URL(string: link)
                cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "n4"), completed: nil)
                cell.title.text = folder
                
                FolderStruct().readNumOfImages(user: username, folderName: folder, completion: { (imagesCount) in
                    FolderStruct().readNumOfVideos(user: username, folderName: folder, completion: { (videosCount) in
                        cell.contentNumber.text = String(imagesCount + videosCount)
                    })
                })
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Create", for: indexPath) as! AddFolderViewCell
            cell.addFolder.image = UIImage.init(named: "icons8-add-50")
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleAdd(tapGesture:)))
            cell.isUserInteractionEnabled = true
            cell.addGestureRecognizer(tapGestureRecognizer)
            return cell
        }
    }
    
    @objc func handleAdd(tapGesture: UITapGestureRecognizer) {
        print("working dog")
        var folderName : String = ""
        
        let alert = UIAlertController(title: "Name Your Folder", message: "Enter the name you wish to use for your folder", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            folderName = textField!.text!
            print("Text field: \(folderName)")
            let newFolder = Folder(folderName: folderName)
            //calling the function to save the folder name to Firebase and create it on the front end
            UserStruct().addFolder(user: UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!, folder: newFolder)
            self.createFolder(folderName: folderName)
        }))
        
        alert.addAction(UIAlertAction(title:"Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveFolder(folderName : String){
        print("saving Folder")
    }
    
    
    func createFolder(folderName: String){
        print("Creating folder: \(folderName)")
        populateFolders()
    }
    
    
    //Should add all folder to FrontEnd
    //The parameter for this function should be an array of Folders (Create the Folders struct)
    func populateFolders(){
        print("reloading data")
    }
    
    func loadDB() {
        print("reached")
        // Not reading database properly
        dbRef.queryOrderedByKey().observe(.value, with: {
            snapshot in
            let value = snapshot.value as? NSDictionary
            print("hey")
            var yourArray = [String]()
            if let scores = snapshot.value as? NSDictionary{
                for i in 0..<scores.count {
                    yourArray.append(scores[i] as! String)
                    print(scores[i])
                }
            }
            self.folderNames = yourArray
        })
        
    }
    
    func setupCollectionViewLayout() {
        let collectionViewLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 5
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: 180, height: 180)
            return layout
        }()
        collectionView.collectionViewLayout = collectionViewLayout
    }
    
    func createBlurEffect() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }
    
    func addSubviews(cell: GemsCollectionViewCell) {
        let blurEffect = createBlurEffect()
        cell.overlayView.addSubview(blurEffect)
        cell.overlayView.addSubview(cell.contentNumber)
        cell.overlayView.addSubview(cell.title)
    }
    
    func designCell(cell: GemsCollectionViewCell) {
        cell.overlayView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        cell.title.textColor = UIColor(white: 1, alpha: 1)
        cell.title.font = UIFont(name: "Helvetica", size: 15)
        cell.contentNumber.textColor = UIColor(white: 1, alpha: 1)
        cell.contentNumber.font = UIFont(name: "Helvetica", size: 15)
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.95, alpha: 1.0).cgColor
        cell.clipsToBounds = true
    }
}
