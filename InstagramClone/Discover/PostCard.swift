//
//  PostCard.swift
//  InstagramClone
//
/*
 DiscoverPage
 */

import UIKit
import AVKit

class PostCard: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelContainer: UIView!
    var likesView = UILabel(frame: CGRect.zero)
    var authorView = UILabel(frame: CGRect.zero)
    let likeButton = LikeButton()
    
    //borders
    var topBorder : UIView?
    var leftBorder : UIView?
    var rightBorder : UIView?
    
    //player variables
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    

    
    ///given a UIImage, Int, and String, and sets the values of the post to the details given
    func buildPostCard(url : URL, likes : Int, author : String) {
        let size = self.frame.size
        
        //imageView
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
        
        //Imageview on Top of View
        imageView!.contentMode = .scaleAspectFill
        imageView!.clipsToBounds = true
        imageView.frame.size = size
        
        buildContainer(likes, author, size)
    }
    
    ///given a URL, Int, and String, and sets the values of the post to the details given
    func buildVideoPostCard(url : URL, likes : Int, author : String) {
        let size = self.frame.size
        
        //video
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        imageView.layer.addSublayer(playerLayer)
        playerLayer.frame = imageView.bounds
        player.play()
        player.isMuted = true
        loopVideo(videoPlayer: player)
        
        imageView!.contentMode = .scaleAspectFill
        imageView!.clipsToBounds = true
        imageView.frame.size = size
        
        buildContainer(likes, author, size)
    }
    
    
    ///builds the view for the likes/author name and borders
    fileprivate func buildContainer(_ likes: Int, _ author: String, _ size: CGSize) {
        //LikesView and author
        likesView.text = String(likes)
        authorView.text = author
        
        //label container
        labelContainer.frame.origin.y = size.height - labelContainer.frame.height
        labelContainer.frame.size.width = self.frame.width
        
        //adding border to cell
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        //border containers
        buildBorderViews()
        addSubviews()
    }
    
    
    
    
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }
    
    
    fileprivate func addSubviews() {
        
        //likeButton
        likeButton.frame.size = CGSize(width: 25, height: 25)
        likeButton.frame.origin = CGPoint(x: 6, y: -2)
        likeButton.isActive = false
        
        
        //Sizing
        likesView.frame.size = CGSize(width: 70, height: 20)
        authorView.frame.size = CGSize(width: (labelContainer.frame.width / 2) - 10, height: 20)
        
        //positioning
        likesView.frame.origin.x = 38
        authorView.frame.origin.x = labelContainer.center.x
        likesView.center.y = labelContainer.frame.height / 2
        authorView.center.y = likesView.center.y - 1
        
        //font
        likesView.font = likesView.font.withSize(17)
        authorView.font = authorView.font.withSize(15)
        authorView.textAlignment = .right
        
        labelContainer.addSubview(likeButton)
        labelContainer.addSubview(likesView)
        labelContainer.addSubview(authorView)
    }
    
    
    func buildBorderViews(){
        let frame = self.frame
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
        if item.link!.contains("mp4") {
            buildVideoPostCard(url: URL(string: item.link!)!, likes: item.numberOfLikes!, author: item.postOwner!)
        } else {
            buildPostCard(url: URL(string: item.link!)!, likes: item.numberOfLikes!, author: item.postOwner!)
        }
    }
    
    
    override var isHighlighted: Bool {
        didSet {
            print("happening: ", self.isHighlighted)
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
        
        imageView.layer.sublayers = nil
        imageView.image = nil
        self.playerItem = nil
        self.player = nil
        self.playerLayer = nil
    }
}
    

