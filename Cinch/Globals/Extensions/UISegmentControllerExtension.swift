//
//  UISegmentControllerExtension.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 1/30/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit



extension UISegmentedControl {
    func removeBorders() {
        let inverseSystemBackground: UIColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
        setBackgroundImage(imageWithColor(color: inverseSystemBackground), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
