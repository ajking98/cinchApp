//
//  HelperFrontEnd.swift
//  Helper
//
//  Created by Gedi on 5/27/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import XLActionController


struct Helper {
    
    func saveToFolder(image: UIImage) -> SpotifyActionController {
        
        let actionController = SpotifyActionController()
        
        actionController.headerData = SpotifyHeaderData(title: "Which folder do you want to save to?", subtitle: "", image: image)
        
        for x in 0 ... 5{
            actionController.addAction(Action(ActionData(title: "Folder #\(x)", subtitle: "For Content"), style: .default, handler: nil))
            
        }
        
        return actionController
    }
}



class ZoomingImage : UIImageView {
    
    
    var longPressedBool = false
    
    init(image : UIImage, frame: CGRect){
        super.init(frame: frame)
        setupView()
        self.image = image
        self.frame = frame
    }
    
    func setupView() {
        self.layer.name = "zooming_image_view"
        self.isUserInteractionEnabled = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    }

class DiscoverBackGround : UIView {
    
    
    let colorDefault = UIColor.black
    let colorOnHold = UIColor.lightGray
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        setupView()
    }
    
    func setupView(){
        self.backgroundColor = colorDefault
        self.alpha = 0
        self.layer.name = "black_background"
        self.isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
    
    
    
    
    
    

