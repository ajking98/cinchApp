//
//  MessageSearchResultViewController.swift
/*
    The screen presented when the user searches a term
 */
//  Created by Alsahlani, Yassin K on 2/7/20.

import Foundation
import Messages
import UIKit


class MessageSearchResultsViewController: SearchResultsViewController {
    
    //Data that must be provided by the presenting view
    var iMessageDelegate: iMessageAppDelegate!
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        iMessageDelegate.minimizeView()
                
        PostStruct().readLink(contentKey: content[indexPath.item], completion: { (link) in
            guard let directory = saveContent(globalLink: link) else { return }
            self.iMessageDelegate.mainConversation.insertAttachment(directory, withAlternateFilename: nil, completionHandler: nil)
        }) {
            print("missing content")
        }
    }
    
}

