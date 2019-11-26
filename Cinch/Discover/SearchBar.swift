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
        self.placeholder = "Search"
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
    
    ///giving the searchBar a padding on the right side
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.clearButtonRect(forBounds: bounds)
        return originalRect.offsetBy(dx: -12, dy: 0)
    }
    
    func buildBorder() {
        //giving the searchbar a padding on the left
        layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 10)
        
        //adds clear button when editing
        self.clearButtonMode = .whileEditing
        
        //variables
        let frame = self.frame
        let size = frame.size
        
        //border
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true
        
        //radius
        self.layer.cornerRadius = size.height/2
        
    }
    
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
        self.endEditing(true)
        guard (self.text?.count == 0) else {
            return
        }
        //reseting icon back to original color
        UIView.animate(withDuration: 0.3) {
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    @objc func handlePressed() {
        guard text!.count == 0 else {
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            //Make border edits
            self.layer.borderWidth = 2
        }
    }
    
    
}
