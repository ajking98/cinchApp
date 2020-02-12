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
    var minimizeView: (() -> Void)!
    var activeConversation = MSConversation()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        minimizeView()
        
        let link = content[indexPath.item] //gets the string version of the link
        guard let url = URL(string: link) else { return } //converts the link to an actual url
        var directory:URL?
        
        if (checkIfVideo(link)) { //handle video
            directory = (saveVideo(videoName: "SelectedVideo.mp4", linkToVideo: url))
        }
        else { //handle image
            if (link.contains("/videos")) { return } //checking to make sure the content is not a video
            directory = saveImage(imageName: "SelectedImage.jpg", linkToImage: url)
        }
        guard directory != nil else { return }
        
        activeConversation.insertAttachment(directory!, withAlternateFilename: nil, completionHandler: nil)
    }
    
}

