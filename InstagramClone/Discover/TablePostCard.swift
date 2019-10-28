//
//  TablePostCard.swift
//
//
//  Created by Ahmed Gedi on 10/12/19.
//

import UIKit
import AVKit

class TablePostCard: UITableViewCell {
    
    
    @IBOutlet weak var tableImageView: UIImageView!
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var topView: UIView!
    
    var likeButton = LikeButton()
    var menuOptions = MenuOptions()
    
    //borders
    var topBorder : UIView?
    var leftBorder : UIView?
    var rightBorder : UIView?
    
    //player variables
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("this is awaking from nib")
        
        setUp()
    }
    
    
    
    ///given an UIImage, Int, and String, and sets the values of the post to the details given
    func buildPostCard(url : URL, likes : Int, author : String) {
        //imageView
        print("building: ,", url)
        tableImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholde.png"), completed: nil)
        tableImageView!.contentMode = .scaleAspectFill
        tableImageView!.clipsToBounds = true

        setUp()
    }
    
    
    ///given a URL, Int, and String, and sets the values of the post to the details given
    func buildVideoPostCard(url : URL, likes : Int, author : String) {
        let size = self.frame.size
        
        //video
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        tableImageView.layer.addSublayer(playerLayer)
        playerLayer.frame = tableImageView.bounds
        player.play()
        player.isMuted = true
        loopVideo(videoPlayer: player)
        
        tableImageView!.contentMode = .scaleAspectFill
        tableImageView!.clipsToBounds = true
        tableImageView.frame.size = size
        
        setUp()
    }
    
    
    fileprivate func setUp() {
        //label container
        let size = self.frame.size
        labelContainer.frame.origin.x = size.width - labelContainer.frame.width
        
        //adding border to cell
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        tableImageView.clipsToBounds = true
        
//        //border containers
//        buildBorderViews()
        
        addSubviews()
    }
    
    
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }
    
    
    fileprivate func addSubviews() {
        let centerX = labelContainer.frame.width / 2
        let bottomY = labelContainer.frame.height
        print("this is the labelContainer: ", labelContainer.frame.size)
        
        //Menu
        menuOptions.center = CGPoint(x: centerX, y: 30)
        menuOptions.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(postActivityController)))
        
        
        //like View
        likeButton.center = CGPoint(x: centerX, y: bottomY - 30)
        
        
        //adding subviews
        labelContainer.addSubview(menuOptions)
        labelContainer.addSubview(likeButton)
    }
    
    
    func buildBorderViews(){
        topBorder = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 4))
        leftBorder = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: frame.height))
        rightBorder = UIView(frame: CGRect(x: frame.width - 4, y: 0, width: 4, height: frame.height))
        
        //coloring (Should add these to the enum of colors)
        topBorder?.backgroundColor = .lightGreen
        leftBorder?.backgroundColor = .lightGreen
        rightBorder?.backgroundColor = .lightGreen
        
        //adding to view
        self.addSubview(topBorder!)
        self.addSubview(leftBorder!)
        self.addSubview(rightBorder!)
    }
    
    ///Given a item, sets the values of the post to that item's values
    func buildPostCard(item : Post) {
        print("got it: ", item.link)
        if item.link!.contains("mp4") {
            buildVideoPostCard(url: URL(string: item.link!)!, likes: item.numberOfLikes!, author: item.postOwner!)
        } else {
            buildPostCard(url: URL(string: item.link!)!, likes: item.numberOfLikes!, author: item.postOwner!)
        }
    }
    
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.15) {
                if(!self.isHighlighted) {
                    self.labelContainer.layer.opacity = 1
                    self.topBorder?.layer.opacity = 1
                    self.leftBorder?.layer.opacity = 1
                    self.rightBorder?.layer.opacity = 1
                    if(self.player != nil) {
                        self.player.isMuted = true
                    }
                    
                }
                else {
                    self.labelContainer.layer.opacity = 0
                    self.topBorder?.layer.opacity = 0
                    self.leftBorder?.layer.opacity = 0
                    self.rightBorder?.layer.opacity = 0
                    if(self.player != nil) {
                        self.player.isMuted = false
                    }
                }
            }
        }
        
    }
    
    
    ///gives the cell its gestures
    func createGestures(target : Any?, action : Selector) {
        self.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        labelContainer.subviews.forEach({$0.removeFromSuperview()})
        
        tableImageView.layer.sublayers = nil
        tableImageView.image = nil
        self.playerItem = nil
        self.player = nil
        self.playerLayer = nil
    }
    
    
    
    //TODO make compatible for videos
    //creates the activity controller when the user taps on the menu options icon
    //only works for images right now
    @objc func postActivityController() {
        print("we reached this far")
        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else { return }
        guard let image = tableImageView.image else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        viewController.present(activityController, animated: true) {
            print("working with the activity controller")
        }
    }
    
}
