//
//  UIViewExtension.swift
//  Created by Ahmed Gedi on 2/17/20.

import Foundation
import UIKit


extension UIView {
    
    var parentViewController: UIViewController? {
        
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as? UIViewController
            }
        }
        return nil
    }
}
