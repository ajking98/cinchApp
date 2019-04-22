//
//  HomeCollectionViewController.swift
//  InstagramClone
//
//  Created by Gedi, Ahmed M on 4/14/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage
import FirebaseStorage


class HomeCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageCollection: UICollectionView!
    var customImageFlowLayout: CustomImageFlowLayout!
    var dbRef: DatabaseReference!
    var images = [ImageInsta]()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        // create a refernce to the database
        dbRef = Database.database().reference().child("images")
        loadDB()
        
        customImageFlowLayout = CustomImageFlowLayout()
        imageCollection.collectionViewLayout = customImageFlowLayout
        imageCollection.backgroundColor = .white
    }
    
    func loadDB() {
        dbRef.observe(DataEventType.value, with: { (snapshot) in
            var newImages = [ImageInsta]()
            for imageInstaSnapshot in snapshot.children {
                let imageInstaObject = ImageInsta(snapshot: imageInstaSnapshot as! DataSnapshot)
                newImages.append(imageInstaObject)
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
        cell.imageView.sd_setImage(with: URL(string: image.url), placeholderImage: UIImage(named: "f1"))
        return cell
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion: nil)
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  {
            
            let storageRef = Storage.storage().reference().child("images" + randomString(20))
            var data = Data()
            data = pickedImage.jpegData(compressionQuality: 0.8)!
            
            // Upload the file to the path "images/rivers.jpg"
            let uploadTask = storageRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let key = self.dbRef.childByAutoId().key
                // You can also access to download URL after upload.
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                }
            }
        }
    }
        
    func randomString(_ length: Int) -> String {
        let letters : NSString = "asdfghjkloiuytrewqazxcvbnmWERTYUIASDFGHJKXCVBN"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }

    @IBAction func loadButtonClicked(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDelegate
    /*
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = self.photoCategories[indexPath.section]
        let image = UIImage(named: category.imageNames[indexPath.item])
        self.performSegue(withIdentifier: Storyboard.showDetailSeque, sender: image)
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showDetailSeque {
            let detailVC = segue.destination as! DetailViewController
            detailVC.image = sender as! UIImage
        }
    }
     */
}
