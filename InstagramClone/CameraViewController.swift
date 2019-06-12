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
        self.pickImage()
    }
    
    
    let uuid = UIDevice.current.identifierForVendor?.uuidString
    let tempUser = User(name: "ahmed", username: "testing2", email: "agedi@mail.com", password: "fjff", isPrivate: false)
    
    @IBAction func testing(_ sender: UIButton) {
        ParentStruct().createUser(user: tempUser)
        ParentStruct().readUser(user: tempUser.username!, userClosure: { (userInfo:User, dateCreated:String, dateLastActive:String, folders:Any) in
            //handle read functionality
            print("printing user: ", userInfo)
            print("printing name: ", userInfo.name!)
            print("printing email: ", userInfo.email!)
            print("printing password: ", userInfo.password!)
            print("printing date created: ", dateCreated)
            print("printing date last active: ", dateLastActive)
            print(folders)
        })
//        var userName = ParentStruct().readUser(user: uuid!)
//        print(userName)
        UserStruct().updateName(user: tempUser.username!, newName: "Yassin")
        UserStruct().updateEmail(user: tempUser.username!, newEmail: "Yassin@gmail.com")
        UserStruct().updatePassword(user: tempUser.username!, newPassword: "nb#$%^i")
        UserStruct().updateIsPrivate(user: tempUser.username!, newIsPrivate: false)
        UserStruct().updateProfilePic(user: tempUser.username!, newProfilePic: tempUser.folder1.icon!)
        UserStruct().updateDateCreated(user: tempUser.username!, newDateCreated: Date())
        UserStruct().updateDateLastActive(user: tempUser.username!, newDateLastActive: Date())
        //        ParentStruct().updateUser(user: uuid!, username: "hfhf")
//        print(UserStruct().readName(user: tempUser.username!, other: tempUser))
        UserStruct().readName(user: tempUser.username!, nameClosure: { (name:String) in
            //handle read functionality
            print("printing name: ", name)
        })
        UserStruct().readEmail(user: tempUser.username!, emailClosure: { (email:String) in
            //handle read functionality
            print("printing email: ", email)
        })
        UserStruct().readPassword(user: tempUser.username!, passwordClosure: { (password:String) in
            //handle read functionality
            print("printing password: ", password)
        })
        UserStruct().readPrivate(user: tempUser.username!, privateClosure: { (isPrivate:Bool) in
            //handle read functionality
            print("printing user privacy: ", isPrivate)
        })
        UserStruct().readProfilePic(user: tempUser.username!, profilePicClosure: { (profilePic:String) in
            //handle read functionality
            print("printing user's profile pic: ", profilePic.toImage()!)
        })
        UserStruct().readDateCreated(user: tempUser.username!, dateCreatedClosure: { (dateCreated:String) in
            //handle read functionality
            print("printing date created: ", dateCreated)
        })
        UserStruct().readDateLastActive(user: tempUser.username!, dateLastActiveClosure: { (dateLastActive:String) in
            //handle read functionality
            print("printing date last active: ", dateLastActive)
        })
        
        FolderStruct().updateDateCreated(user: tempUser.username!, folderName: "personal", newDateCreated: Date())
        FolderStruct().updateDateLastModified(user: tempUser.username!, folderName: "personal", newDateLastModified: Date())
        FolderStruct().updateIcon(user: tempUser.username!, folderName: "personal", newIcon: "newUrl")
        FolderStruct().updateIsPrivate(user: tempUser.username!, folderName: "personal", newIsPrivate: true)
        FolderStruct().updateNumOfImages(user: tempUser.username!, folderName: "personal", newNumOfImages: 6)
        FolderStruct().updateNumOfVideos(user: tempUser.username!, folderName: "personal", newNumOfVideos: 12)
        
        FolderStruct().readDateCreated(user: tempUser.username!, folderName: "personal", dateCreatedClosure: { (dateCreated:String) in
            //handle read functionality
            print("printing folder date created: ", dateCreated)
        })
        
        FolderStruct().readDateLastModified(user: tempUser.username!, folderName: "personal", dateLastModifiedClosure: { (dateLastModified:String) in
            //handle read functionality
            print("printing folder date last modified: ", dateLastModified)
        })
        FolderStruct().readIcon(user: tempUser.username!, folderName: "personal", folderIconClosure: { (icon:String) in
            //handle read functionality
            print("printing folder icon: ", icon)
        })
        
        FolderStruct().readNumOfImages(user: tempUser.username!, folderName: "personal", numOfImagesClosure: { (numOfImages:Int) in
            //handle read functionality
            print("printing number of images in folder: ", numOfImages)
        })
        FolderStruct().readNumOfVideos(user: tempUser.username!, folderName: "personal", numOfVideosClosure: { (numOfVideos:Int) in
            //handle read functionality
            print("printing number of videos in folder: ", numOfVideos)
        })
        
        FolderStruct().readPrivate(user: tempUser.username!, folderName: "personal", isPrivateClosure: { (isPrivate:Bool) in
            //handle read functionality
            print("printing privacy of folder: ", isPrivate)
        })
        var funny = Folder(folderName: "funny")
        UserStruct().createFolder(user: tempUser.username!, folder: funny)
        UserStruct().readFolders(user: tempUser.username!, readFolderClosure: {(folders:[String]) in
            for item in folders {
                print(item)
            }
        })
        
//        UserStruct().deleteFolder(user: tempUser.username!, folderName: "funny")
        UserStruct().updateFolder(user: tempUser.username!, prevFolderName: "funny", newFolderName: "lame", prevFolderainfo: tempUser.folder1)

        StorageStruct().UploadProfilePic(user: tempUser.username!, image: tempUser.profilePic!)
        StorageStruct().UploadFolderIcon(user: tempUser.username!, folderName: tempUser.folder1.folderName!, image: tempUser.folder1.icon!)
//        StorageStruct().UploadContent(user: uuid!, folderName: tempUser.folder1.folderName!, content: tempUser.folder1.icon!)
    
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
        //imageView?.isUserInteractionEnabled = true
        //imageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector()))
        
        
        //Swipe left
        var swipe = UISwipeGestureRecognizer(target: self, action: #selector(openDiscoverView))
        swipe.direction = .right
        view.addGestureRecognizer(swipe)
        
        
        //Swipe right
        swipe = UISwipeGestureRecognizer(target: self, action: #selector(openProfileView))
        swipe.direction = .left
        view.addGestureRecognizer(swipe)
    }
    
    
    
    func pickImage(){
        //Picking the image from photoLibrary
        let image = UIImagePickerController()
//        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        
//        self.present(image, animated: true)
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
        var action = SpotifyActionController.init()
        if let image = imageView.image {
            action = Helper().saveToFolder(image: image)
        }
        present(action, animated: true, completion: nil)
        
        
        self.imageView.image = nil
        sender.isHidden = true
    }
    
    @objc func openDiscoverView() {
        self.tabBarController?.selectedIndex = 0
    }
    
    @objc func openProfileView() {
        self.tabBarController?.selectedIndex = 2
    }

}
