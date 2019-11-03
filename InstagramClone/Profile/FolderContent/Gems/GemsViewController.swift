//
//  GemsViewController.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 6/23/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.

import UIKit
import Cards

class GemsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    let cellIdentifier = "GemCell"
    
    //TODO THESE should hold actual folder objects
    var folders : [Folder] = []
    var username = ""
    var isLocalUser = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if username == "" {
            username = String(UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!)
            buildAddFolderButton()
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        setupCollectionViewLayout()
        
        fetchFolders()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.set(nil, forKey: defaultsKeys.otherProfile)
    }
    
    
    func buildAddFolderButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.setImage(UIImage(named: "plus_icon_gray"), for: .normal)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleAdd(tapGesture:)))
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(tapGestureRecognizer)
        button.backgroundColor = .lightGreen
        
        let width = view.frame.width
        let height = view.frame.height
        button.layer.cornerRadius = button.frame.width / 2
        button.clipsToBounds = true
        button.center = CGPoint(x: (width * 3)/4.5, y: (height) / 4)
        view.addSubview(button)
    }
    
    func fetchFolders() {
        UserStruct().readCompleteFolders(user: username) { (folderList) in
            for folder in folderList {
                let indexPath = IndexPath(item: self.folders.count, section: 0)
                self.folders.append(folder)
                self.collectionView.insertItems(at: [indexPath])
            }
        }
    }
    
    
    ///Is called to pull the latest changes done to a folder
    func updateLocalFolders() {
        UserStruct().readCompleteFolders(user: username) { (folderList) in
            self.folders = folderList
        }
    }
    
    
    //Sets up the Viewcontroller for when the folder is tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FolderCotent") as! FolderContent
        
        vc.folderName = folders[indexPath.row].folderName
        present(vc, animated: true, completion: nil)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GemsCollectionViewCell
            designCell(cell: cell)
        
        let folder = folders[indexPath.row]
        let url = URL(string: folder.iconLink!)
        cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named : "n2"), completed: nil)
        cell.title.text = folder.folderName
        cell.contentNumber.text = String(folder.numOfImages + folder.numOfVideos)
        return cell
    }
    
    @objc func handleAdd(tapGesture: UITapGestureRecognizer) {
        print("working dog")
        var folderName : String = ""
        
        let alert = UIAlertController(title: "Name Your Folder", message: "Assign a title to this folder", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            folderName = textField!.text!.lowercased()
            let newFolder = Folder(folderName: folderName)
            
            //if a folder with that name already exists, then it wont overwrite it
            if self.folders.contains(where: { (tempFolder) -> Bool in
                return tempFolder.folderName == folderName
            }){
                let alert = UIAlertController(title: "ERROR", message: "A folder with title: \"\(folderName)\" already exits. \n Try a different title.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                //calling the function to save the folder name to Firebase and create it on the front end
                UserStruct().addFolder(user: self.username, folder: newFolder)
                self.createFolder(folderName: folderName)
            }
        }))
        
        alert.addAction(UIAlertAction(title:"Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveFolder(folderName : String){
        print("saving Folder")
    }
    
    
    func createFolder(folderName: String){
        let folder = Folder(folderName: folderName)
        UserStruct().addFolder(user: username, folder: folder)
        UserStruct().readSingleFolder(user: username, folderName: folderName) { (newFolder) in
            let indexPath = IndexPath(item: self.folders.count, section: 0)
            self.folders.append(newFolder)
            self.collectionView.insertItems(at: [indexPath])
        }
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
