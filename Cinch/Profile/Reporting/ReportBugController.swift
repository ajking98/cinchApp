//
//  ReportBugController.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 8/8/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import AVKit

class ReportBugController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var playerItem: AVPlayerItem!
    var players = [AVPlayer]()
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var togglePause = true
    
    let firebaseVideos = ["https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/images%2Famberalerts.mp4?alt=media&token=92f4cb5f-0aeb-4674-86f4-9f6ed9e05604", "https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/images%2Ffire.mp4?alt=media&token=cb204eee-6444-407e-953c-a6367a8cc7e8", "https://firebasestorage.googleapis.com/v0/b/instagramclone-18923.appspot.com/o/images%2Fwaterbend.mp4?alt=media&token=dd6fb189-03c2-4c3a-9f51-2559645e631a"]
    
    let cellIdentifier = "testcell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closeAction(_:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(swipeDown)
        // Do any additional setup after loading the view.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    @IBAction func closeAction(_ sender: Any) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
            self.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ReportBugController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return firebaseVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ReportCell
        print(collectionView.indexPathsForVisibleItems)
        //        let path = Bundle.main.path(forResource: "waterbend", ofType: "mp4")
        //        let player = AVPlayer(url: URL(fileURLWithPath: path!))
        let url = URL(string: firebaseVideos[indexPath.row])!
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        players.append(player)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        cell.videoView.layer.addSublayer(playerLayer)
        playerLayer.frame = cell.videoView.bounds
        players[indexPath.row].play()
        print(player.currentItem)
        player.isMuted = true
        //        loopVideo(videoPlayer: player)
        
        return cell
    }
    
//        func loopVideo(videoPlayer: AVPlayer) {
//            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
//                videoPlayer.seek(to: CMTime.zero)
//                videoPlayer.play()
//            }
//        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        players[indexPath.row].isMuted = false
        players[indexPath.row].seek(to: CMTime.zero)
        players[indexPath.row].play()
        print(players[indexPath.row].currentItem)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            print(self.players[indexPath.row].currentTime().seconds)
            self.players[indexPath.row].seek(to: CMTime.zero)
            self.players[indexPath.row].pause()
        }
        //        if togglePause {
        //            players[indexPath.row].pause()
        ////            player.pause()
        ////            player.isMuted = true
        //            self.togglePause = false
        //        } else {
        //            players[indexPath.row].play()
        ////            player.play()
        ////            player.isMuted = false
        //            self.togglePause = true
        //        }
        
    }
}
