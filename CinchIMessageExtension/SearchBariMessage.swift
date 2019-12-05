//
//  SearchBariMessage.swift
//  CinchIMessageExtension
//
//  Created by Alsahlani, Yassin K on 12/4/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit


protocol SearchiMessageDelegate : class {
    func expandView()
    func buildSearchView()
}

class SearchBariMessage: SearchBar {
    
    weak var delegate2: SearchiMessageDelegate?
    
    
    @objc override func handlePressed() {
        delegate2?.expandView()
        super.handlePressed()
        print("thiis printing something")
    }
    
    
    @objc override func textFieldTyping() {
        super.textFieldTyping()
        print("texting ssomething")
    }
    
    
    @objc override func handleEditingEnded() {
        super.handleEditingEnded() 
        print("we are ending the edit son")
    }
}
