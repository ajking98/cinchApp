//
//  StringExtension.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 2/10/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import Foundation


extension String {
    func capitalizeFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
