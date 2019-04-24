//
//  CameraViewController.swift
//  InstagramClone
//
/*
        Prompted when user uploads image from camera roll and a delegate is used
 
 */


import UIKit
import EasyImagy
import Firebase
import FirebaseDatabase
import FirebaseStorage
import XLActionController

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var findImage: UIButton!
    var dbRef: DatabaseReference!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func onSelectImage(_ sender: UIButton) {
        //Picking the image from photoLibrary
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    
    
    
    let button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Add button (+)
        button.frame = CGRect(x: UIScreen.main.bounds.width - 85, y: findImage.frame.minY - 65, width: 50, height: 50)
        button.backgroundColor = .green
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        button.layer.shadowOpacity = 0.25
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.shadowRadius = 2
        button.contentVerticalAlignment = .top
        button.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        button.isHidden = true
        self.view.addSubview(button)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            let image2 = trimInsta(image : image)
            imageView.image = image2
            
            button.isHidden = false
            
            // data in memory
            var data = Data()
            data = image2.jpegData(compressionQuality: 0.8)!
            
            let refImages = Database.database().reference().child("images")
            let storageRef = Storage.storage().reference().child("images/" + randomString(20))
            print(storageRef.name)
            
            // Upload the file to the path "images/rivers.jpg"
            _ = storageRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print("Error occurred")
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                
                // You can also access to download URL after upload.
                storageRef.downloadURL { (url, error) in
                    if (error == nil) {
                        if let downloadUrl = url {
                            // Make you download string
                            let key = refImages.childByAutoId().key
                            let image = ["url": downloadUrl.absoluteString]
                            refImages.child(key).setValue(image)
                        }
                    }
                    guard let url = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                }
            }

            
        }
        else{
            print("Error has occured loading up the image")
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
    
    func trimInsta(image : UIImage) -> UIImage {
        var instaImage = Image<RGBA<UInt8>>(uiImage: image)
        var start = 0
        let width = instaImage.width
        let height = instaImage.height
        let distToBookmark = 28
        
        for y in 0 ..< height {
            if(instaImage[0, y].green < 240){
                print("We are at:", instaImage[0, y], y)
                start = y
                break
            }
        }
        
        start = start + 10
        for y in start ..< height {
            if(instaImage[0, y].green < 250){
                print("this is the start:", y)
                start = y
                break
            }
        }
        
        
        //END
        
        var end = start + 553
        let sizes = [553, 615, 828, 1035]
        for size in (0 ..< sizes.count).reversed() {
            var white = true
            end = start + sizes[size]
            for y in (end + 3) ... (end + 10){
                if(instaImage[760, y].green < 250){
                    print("Not white")
                    white = false
                    break
                }
                
                if(!white){
                    continue
                }
                print("yes")
                for y in (end + 10) ..< (end + distToBookmark + 3){
                    if(instaImage[760, y].green < 50){
                        print("Start:", start, "End", end)
                        let slice: ImageSlice<RGBA<UInt8>> = instaImage[0 ..< width, start ..< end]
                        let cropped = Image<RGBA<UInt8>>(slice)
                        print((instaImage[460,2]).green)
                        print(instaImage.count)
                        return cropped.uiImage
                    }
                }
            }
        }
        
        let slice: ImageSlice<RGBA<UInt8>> = instaImage[0 ..< width, 0 ..< height]
        let cropped = Image<RGBA<UInt8>>(slice)
        print((instaImage[460,2]).green)
        print("This isn't an Instagram image")
        return cropped.uiImage
    }
    
    @objc func saveImage(sender: UIButton!){
        let actionController = SpotifyActionController()
        if let image = imageView.image {
            actionController.headerData = SpotifyHeaderData(title: "Which folder do you want to save to?", subtitle: "", image: image)
        }
        for x in 0 ... 5{
            actionController.addAction(Action(ActionData(title: "Folder #\(x)", subtitle: "For Content"), style: .default, handler: nil))

        }
        present(actionController, animated: true, completion: nil)
        
        self.imageView.image = nil
        sender.isHidden = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
