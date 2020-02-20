//
//  iMessageGlobals.swift
//  iMessage
//
//  Created by Alsahlani, Yassin K on 2/11/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import UIKit



///takes a global link to the content content, then saves it and returns a local url to the location
func saveContent(globalLink: String) -> URL? {
       guard let url = URL(string: globalLink) else { return nil } //converts the link to an actual url
       var directory:URL?

       if (checkIfVideo(globalLink)) { //handle video
           directory = saveVideo(videoName: "SelectedVideo.mp4", linkToVideo: url)
       }
       else { //handle image
           if (globalLink.contains("/videos")) { return nil } //checking to make sure the content is not a video
           directory = saveImage(imageName: "SelectedImage.jpg", linkToImage: url)
       }
       guard directory != nil else { return nil }
    
    return directory
}


