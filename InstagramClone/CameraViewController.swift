//
//  CameraViewController.swift
//  InstagramClone
//
//  Created by Gedi, Ahmed M on 4/11/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import EasyImagy

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBAction func onSelectImage(_ sender: UIButton) {
        //Picking the image from photoLibrary
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = true
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            let image2 = trimInsta(image : image)
            imageView.image = image2
        }
        else{
            print("Error has occured loading up the image")
        }
        
        self.dismiss(animated: true, completion: nil)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
