//
//  Global.swift
//  InstagramClone
//
//  Created by Gedi on 8/3/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit

public enum constants: CGFloat {
    case baseVelocity = 820.0
}

func isQuickSwipe(velocity : CGFloat) -> Bool {
    if abs(velocity) > constants.baseVelocity.rawValue {
        return true
    }
    return false
}

extension UIColor {
    static let normalGreen = UIColor(red: 0.016, green: 0.8196, blue: 0.592, alpha: 1)
    static let darkerGreen = UIColor(red: 0.247, green: 0.627, blue: 0.522, alpha: 1)
    
}

