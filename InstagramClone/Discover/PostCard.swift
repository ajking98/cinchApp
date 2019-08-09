//
//  PostCard.swift
//  InstagramClone
//
/*
 DiscoverPage
 */

import UIKit

class PostCard: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelContainer: UIView!
    var likesView = UILabel(frame: CGRect.zero)
    var authorView = UILabel(frame: CGRect.zero)
    let likeButton = LikeButton()
    
    var setHeight : CGFloat?
    
    //borders
    var topBorder : UIView?
    var leftBorder : UIView?
    var rightBorder : UIView?
    
    
    ///given an UIImage, Int, and String, and sets the values of the post to the details given
    func buildPostCard(image : UIImage, likes : Int, author : String) {
        let size = self.frame.size
        
        //imageView
        imageView.image = image
        imageView!.contentMode = .scaleAspectFill
        imageView!.clipsToBounds = true
        imageView.frame.size = size
        
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
    func buildPostCard(item : Item) {
        buildPostCard(image: UIImage(named: item.imageName)!, likes: item.likes, author: item.author)
    }
    
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.15) {
                if(self.labelContainer.layer.opacity == 0) {
                    self.labelContainer.layer.opacity = 1
                    self.topBorder?.layer.opacity = 1
                    self.leftBorder?.layer.opacity = 1
                    self.rightBorder?.layer.opacity = 1
                }
                else {
                    self.labelContainer.layer.opacity = 0
                    self.topBorder?.layer.opacity = 0
                    self.leftBorder?.layer.opacity = 0
                    self.rightBorder?.layer.opacity = 0
                }
            }
        }
        
    }
    
    ///gives the cell its gestures
    func createGestures(target : Any?, action : Selector) {
        self.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
    
    
}
