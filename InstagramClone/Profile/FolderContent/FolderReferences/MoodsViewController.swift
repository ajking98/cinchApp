//
//  ReactionsViewController.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 6/23/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit


class FolderReferenceController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier = "MoodCell"
    var folderRefs : [FolderReference] = []
    var folders : [Folder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        setupCollectionViewLayout()
        
        
        let folderRefArray = UserDefaults.standard.array(forKey: defaultsKeys.foldersFollowing) as! [[String : String]]
        for index in 0..<folderRefArray.count {
            
            let admin = folderRefArray[index]["admin"]
            let folderName = folderRefArray[index]["folderName"]
            folderRefs.append(FolderReference(admin: admin!, folderName: folderName!))
        }
    }
    
    
    ///Pulls the latest changes done and stores them locally
    func updateLocalFolders() {
        for index in 0..<folderRefs.count {
            let username = folderRefs[index].admin
            let folderName = folderRefs[index].folderName
            UserStruct().readSingleFolder(user: username, folderName: folderName) { (folder) in
                self.folders.append(folder)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //If the user isn't currently following any folders
        guard folderRefs.count > 0 else {
            let messageView = UILabel(frame: collectionView.frame)
            messageView.text = "Folders you follow will appear here"
            messageView.textAlignment = .center
            messageView.backgroundColor = .darkerGreen
            messageView.textColor = .white
            messageView.center = CGPoint(x: collectionView.center.x, y: collectionView.center.y - 40)
            collectionView.addSubview(messageView)
            return 0
        }
        
        
        if folders.count == 0 {
            updateLocalFolders()
        }
        return folderRefs.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FolderCotent") as! FolderContent
        guard let cell = collectionView.cellForItem(at: indexPath) as? MoodsCollectionViewCell else {
            return
        }
        
        vc.folderName = folders[indexPath.row].folderName
        vc.username = cell.username
        present(vc, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MoodsCollectionViewCell
        designCell(cell: cell)
        
        let folderRef = folderRefs[indexPath.row]
        let username = folderRef.admin
        let folderName = folderRef.folderName
        
        cell.title.text = folderName
        cell.username = username
        
        FolderStruct().readIcon(user: username, folderName: folderName) { (link) in
            let url = URL(string: link)
            cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "n2"), completed: nil)
        }
    
        FolderStruct().readNumOfImages(user: username, folderName: folderName) { (numberOfImages) in
            FolderStruct().readNumOfVideos(user: username, folderName: folderName, completion: { (numberOfVideos) in
                cell.contentNumber.text = String(numberOfImages + numberOfVideos)
            })
        }
        
        addSubviews(cell: cell)
        return cell
    }
    
    
    @objc func handleAdd(tapGesture: UITapGestureRecognizer) {
        var folderName : String = ""
        
        let alert = UIAlertController(title: "Name Your Folder", message: "Enter the name you wish to use for your folder", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            folderName = textField!.text!
            print("Text field: \(folderName)")
            let newFolder = Folder(folderName: folderName)
            //calling the function to save the folder name to Firebase and create it on the front end
//            UserStruct().addFolder(user: UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!, folder: newFolder)
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
        print("Populating")
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
    
    func addSubviews(cell: MoodsCollectionViewCell) {
        let blurEffect = createBlurEffect()
        cell.overlayView.addSubview(blurEffect)
        cell.overlayView.addSubview(cell.contentNumber)
        cell.overlayView.addSubview(cell.title)
    }
    
    func designCell(cell: MoodsCollectionViewCell) {
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

