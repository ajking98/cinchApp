//
//  UINavigationControllerExtension.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 3/2/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit



extension UINavigationController {
    @objc func dismissAlert() {
        print("this is dismissing")
        dismiss(animated: true, completion: nil)
    }
}
