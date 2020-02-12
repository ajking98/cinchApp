//
//  InitialiMessageVC.swift
//  iMessage
//
//  Created by Alsahlani, Yassin K on 2/12/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit
import Messages


class InitialiMessageVC: MSMessagesAppViewController, iMessageAppDelegate {
    var mainConversation = MSConversation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = MessagesViewController()
        vc.iMessageDelegate = self
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    
    override func didBecomeActive(with conversation: MSConversation) {
        mainConversation = conversation
        print("activity is working:", conversation)
    }
    
    
    ///Makes the extension take up the full screen
    func expandView() -> (Void) {
        print("this is activity")
        if presentationStyle == .compact {
            requestPresentationStyle(.expanded)
        }
    }
    
    ///Shrinks the size of the extension
    func minimizeView() -> (Void) {
        if presentationStyle == .expanded {
            requestPresentationStyle(.compact)
        }
    }
    
    func getPresentationStyle() -> (MSMessagesAppPresentationStyle) {
        return presentationStyle
    }
    
}

