//
//  MessageSearchResultViewController.swift
//  iMessage
//
//  Created by Alsahlani, Yassin K on 2/7/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit


class MessageSearchResultsViewController: SearchResultsViewController {
    
    var minimizeView: (() -> Void)!
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("we are selecting")
        minimizeView()
    }
    
}

