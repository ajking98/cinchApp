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

