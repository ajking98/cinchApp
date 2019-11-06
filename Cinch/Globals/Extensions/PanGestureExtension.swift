//
//  PanGestureExtension.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 10/19/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Direction
enum Direction {
    case up
    case down
    case left
    case right
}

//MARK: - UIPanGestureRecognizer
public extension UIPanGestureRecognizer {
    internal var direction : Direction? {
        let speed = velocity(in: view).y
        return(speed > 0 ? .up : .down)
    }
}
