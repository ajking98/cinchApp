//
//  Global.swift
//  Cinch
//
//  Created by Gedi on 8/3/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit
import ImageIO


public enum constants: CGFloat {
    case baseVelocity = 820.0
}

func isQuickSwipe(velocity : CGFloat) -> Bool {
    if abs(velocity) > constants.baseVelocity.rawValue {
        return true
    }
    return false
}

///updates y-axis of view by given translation
func followFingerVertical(view : UIView, translation : CGPoint) {
    view.center.y += translation.y
}

///Takes in a string to a link and updates to a new value that could be used in the key place on Firebase
func convertStringToKey(link : String) -> String {
    var updatedLink = ""   //Updating the link of the url because firebase doesn't take "." in the key
    for index in link {
        if (index == ".") {
            updatedLink.append("`")
        }
        else if(index == "/") {
            updatedLink.append("^")
        }else {
            updatedLink.append(index)
        }
    }
    return updatedLink
}




