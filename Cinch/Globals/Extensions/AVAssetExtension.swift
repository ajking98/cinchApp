//
//  AVAssetExtension.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 2/25/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import Foundation
import AVFoundation


extension AVAsset {
    func assetByTrimming(timeOffStart: Double) throws -> AVAsset {
        let duration = CMTime(seconds: timeOffStart, preferredTimescale: 1)
        let timeRange = CMTimeRange(start: CMTime.zero, duration: duration)

        let composition = AVMutableComposition()

        do {
            for track in tracks {
                let compositionTrack = composition.addMutableTrack(withMediaType: track.mediaType, preferredTrackID: track.trackID)
                try compositionTrack?.insertTimeRange(timeRange, of: track, at: CMTime.zero)
            }
        } catch let error {
            throw TrimError("error during composition", underlyingError: error)
        }

        return composition
    }

    func export(to destination: URL) throws {
        guard let exportSession = AVAssetExportSession(asset: self, presetName: AVAssetExportPresetPassthrough) else {
            throw TrimError("Could not create an export session")
        }
        
        exportSession.outputURL = destination
        exportSession.outputFileType = AVFileType.m4v
        exportSession.shouldOptimizeForNetworkUse = true
        
        let group = DispatchGroup()
        
        group.enter()
        
        try FileManager.default.removeFileIfNecessary(at: destination)
        
        exportSession.exportAsynchronously {
            group.leave()
        }
        
        group.wait()
        
        if let error = exportSession.error {
            throw TrimError("error during export", underlyingError: error)
        }
    }
}

func time(_ operation: () throws -> ()) rethrows {
    let start = Date()

    try operation()

    let end = Date().timeIntervalSince(start)
    print(end)
}


