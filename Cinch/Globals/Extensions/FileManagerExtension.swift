//
//  FileManagerExtension.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 2/25/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import AVFoundation


extension FileManager {
    func removeFileIfNecessary(at url: URL) throws {
        guard fileExists(atPath: url.path) else {
            return
        }

        do {
            try removeItem(at: url)
        }
        catch let error {
            throw TrimError("Couldn't remove existing destination file: \(error)")
        }
    }
}

struct TrimError: Error {
    let description: String
    let underlyingError: Error?

    init(_ description: String, underlyingError: Error? = nil) {
        self.description = "TrimVideo: " + description
        self.underlyingError = underlyingError
    }
}

extension AVMutableComposition {
    convenience init(asset: AVAsset) {
        self.init()
        
        for track in asset.tracks {
            addMutableTrack(withMediaType: track.mediaType, preferredTrackID: track.trackID)
        }
    }
    
    func trim(timeOffStart: Double) {
        let duration = CMTime(seconds: timeOffStart, preferredTimescale: 1)
        let timeRange = CMTimeRange(start: CMTime.zero, duration: duration)
        
        for track in tracks {
            track.removeTimeRange(timeRange)
        }
        
        removeTimeRange(timeRange)
    }
}

