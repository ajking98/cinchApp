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
