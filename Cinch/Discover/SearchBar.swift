//
//  SearchBar.swift
//  Cinch
//
//  Created by Ahmed Gedi on 7/4/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit


protocol SearchDelegate : class {
    func search(searchTerm : String)
}

class SearchBar: UITextField {
    
//    var iconView : UIImageView?
//    var iconViewSize : CGSize?
    var isDrawn = false
    weak var searchDelegate : SearchDelegate?
    
    
    override func draw(_ rect: CGRect) {
        if isDrawn {
            return
        }
        buildBorder()
        buildSpacing()
//        buildIcon() //adds search icon to the left with padding
        buildGestures() //builds all gestures for view
//        iconViewSize = iconView?.frame.size
        
        isDrawn = true
    }
    
    func buildBorder() {
        //adds clear button when editing
        self.clearButtonMode = .whileEditing
        
        //variables
        let frame = self.frame
        let size = frame.size
        
        //border
        self.layer.borderColor = UIColor(red: 0.012, green: 0.992, blue: 0.716, alpha: 1.0).cgColor
        self.clipsToBounds = true
        
        //radius
        self.layer.cornerRadius = size.height/2
    }
    
    // TODO Consider deleting icon completely
//    fileprivate func buildIcon() {
//        //spacing
//        let leftView = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
//        self.leftView = leftView
//        self.leftViewMode = .always
//        self.contentVerticalAlignment = .center
//
//
//        //adding search icon
//        let searchIcon = UIImage(named: "searchIcon")
//        iconView = UIImageView(image: searchIcon)
//        iconView!.frame.origin = CGPoint(x: 290, y: 5)
//        self.addSubview(iconView!)
//    }
    
    func buildSpacing() {
        let leftView = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        self.leftView = leftView
        self.leftViewMode = .always
        self.contentVerticalAlignment = .center

    }
    
    
    func buildGestures() {
        addTarget(self, action: #selector(handlePressed), for: UIControl.Event.editingDidBegin)
        addTarget(self, action: #selector(textFieldTyping), for: UIControl.Event.editingChanged)
    }
    
    
    @objc func textFieldTyping() {
        guard let text = text else { return }
        searchDelegate?.search(searchTerm: text)
    }
    
    //reverts back to original position when the focus is no longer on the search bar and the search bar is empty
    @objc func revertToNormal(){
        print("active2")
        self.endEditing(true)
        guard (self.text?.count == 0) else {
            return
        }
        //reseting icon back to original color
//        iconView?.image = UIImage(named: "searchIcon")
        UIView.animate(withDuration: 0.3) {
            //reserse border edits
            self.layer.borderWidth = 0
            
            //reverse icon edits
//            self.iconView!.frame.size = self.iconViewSize!
//            self.iconView!.center.y = 16
        }
    }
    
    @objc func handlePressed() {
        //making icon green
        print("active")
//        iconView?.image = UIImage(named: "searchIconGreen")
        
        guard text!.count == 0 else {
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            //Make border edits
            self.layer.borderWidth = 2
            
            //make icon edits
//            let size = CGSize(width: self.iconViewSize!.width + 10, height: self.iconViewSize!.height + 10)
//            self.iconView?.frame.size = size
//            self.iconView?.center.y -= 5
        }
    }
    
    
}
