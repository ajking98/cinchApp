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
        let contentKey = self.content[self.content.index(self.content.startIndex, offsetBy: indexPath.item)]
        
        // If content is from memes.com
        if contentKey.contains("memes.com") {
            guard let directory = saveContent(globalLink: contentKey) else { return }
            self.iMessageDelegate.mainConversation.insertAttachment(directory, withAlternateFilename: nil, completionHandler: nil)
            return
        }
        
        PostStruct().readLink(contentKey: contentKey, completion: { (link) in
            guard let directory = saveContent(globalLink: link) else { return }
            self.iMessageDelegate.mainConversation.insertAttachment(directory, withAlternateFilename: nil, completionHandler: nil)
        }) {
            print("missing content")
        }
    }
    
}

