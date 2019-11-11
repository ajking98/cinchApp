//
//  PermissionsController.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 6/19/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import Photos

class PermissionsController: UIViewController {
    @IBOutlet weak var outerMost: UIView!
    @IBOutlet weak var middle: UIView!
    @IBOutlet weak var innerMost: UIView!
    @IBOutlet weak var gotItButton: UIButton!
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var centerIcon: UIImageView!
    @IBOutlet weak var permissionMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildCircles()
        buildBorder()
        underline()
        buildGestures()
    }
    
    func buildGestures(){
        
        //center Icon Button
        centerIcon.isUserInteractionEnabled = true
        centerIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(askForPermission)))
        
        //OK GOT IT button
        gotItButton.isUserInteractionEnabled = true
        gotItButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(askForPermission)))
        
        //cancel label
        cancelLabel.isUserInteractionEnabled = true
        cancelLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(exitView)))
        
        
        //Swipe DOWN
        view.isUserInteractionEnabled = true
        var swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(exitView))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    func buildCircles(){
        outerMost.layer.cornerRadius = outerMost.frame.width/2
        middle.layer.cornerRadius = middle.frame.width / 2
        innerMost.layer.cornerRadius = innerMost.frame.width/2
        gotItButton.layer.cornerRadius = gotItButton.frame.height/2
    }
    
    func buildBorder(){
        innerMost.layer.borderWidth = 3
        innerMost.layer.borderColor = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF, alpha: 1).cgColor
        
        gotItButton.layer.borderWidth = 1
        gotItButton.layer.borderColor = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF, alpha: 1).cgColor
    }
    
    func underline() {
        let spacing = 0.5
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = cancelLabel.textColor
        cancelLabel.addSubview(line)
        cancelLabel.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[line]|", metrics: nil, views: ["line":line]))
        cancelLabel.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(1)]-(\(-spacing))-|", metrics: nil, views: ["line":line]))
    }
    
    func enterCameraView(){
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name : "Main", bundle: nil)
        let myviewController  :UIViewController = mainView.instantiateViewController(withIdentifier: "TabBarID") as UIViewController
        self.present(myviewController, animated: true, completion: nil)
    }
    
    @objc func askForPermission(_ tapGesture : UITapGestureRecognizer? = nil) {
        PHPhotoLibrary.requestAuthorization({status in
            if status == .authorized{
                self.enterCameraView()
            } else { PHPhotoLibrary.requestAuthorization({status in
                print(status)
            }) }
        })
        
        
        let permissionStatus = PHPhotoLibrary.authorizationStatus()
        if(permissionStatus == .restricted || permissionStatus == .denied){
            let alert = UIAlertController(title: "APP RESTRICTED", message: "you have restricted this app from accessing your photos. Grant permission by going into your settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    
    @objc func exitView(_ tapGesture : UITapGestureRecognizer? = nil){
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name : "Main", bundle: nil)
        let myviewController  :UIViewController = mainView.instantiateViewController(withIdentifier: "TabBarID") as UIViewController
        self.present(myviewController, animated: true, completion: nil)
    }


}
