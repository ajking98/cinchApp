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
    @IBOutlet weak var likesView: UILabel!
    @IBOutlet weak var authorView: UILabel!
    @IBOutlet weak var labelContainer: UIView!
    
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
        likesView?.text = String(likes)
        authorView.text = author
        
        //label container
        labelContainer.frame.origin.y = size.height - labelContainer.frame.height
        labelContainer.frame.size.width = self.frame.width
        
        
        //adding border to cell
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        
        //border containers
        buildBorderViews()
    }
    
    func buildBorderViews(){
        let frame = self.frame
        topBorder = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 4))
        leftBorder = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: frame.height))
        rightBorder = UIView(frame: CGRect(x: frame.width - 4, y: 0, width: 4, height: frame.height))
        
        //coloring (Should add these to the enum of colors)
        topBorder?.backgroundColor = UIColor(red: 0.608, green: 0.937, blue: 0.847, alpha: 1)
        leftBorder?.backgroundColor = UIColor(red: 0.608, green: 0.937, blue: 0.847, alpha: 1)
        rightBorder?.backgroundColor = UIColor(red: 0.608, green: 0.937, blue: 0.847, alpha: 1)
        
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

//extension DiscoverController  {
//    @objc func handlePressed(tapGesture : UITapGestureRecognizer) {
//        if let Post = tapGesture.view as? PostCard {
//            print("handling")
//            performSegue(withIdentifier: viewImageSegueIdentifier, sender: Post)
//        }
//    }
//}
