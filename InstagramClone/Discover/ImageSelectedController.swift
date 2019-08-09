//
//  ImageSelectedController.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 7/5/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class ImageSelectedController: UIViewController {
    var items : [Item] = [Item]()
    var discoverController : DiscoverController?
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lowerView: UIView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var labels: UIView!
    var likeButton = LikeButton()
    var shareButton = ShareButton()
    var likesView = UILabel(frame: CGRect.zero)
    var authorView = UILabel(frame: CGRect.zero)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("this is your frame: ", discoverController?.collectionView.frame)
        setUp()
        
        setUpScrollView()
        print(scrollView.isUserInteractionEnabled, "the user interaction is enabled")
    }
    
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        postImage.centerXAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerXAnchor)
//        postImage.centerYAnchor.constraint(equalTo: scrollView.contentLayoutGuide.centerYAnchor)
//        return postImage
//    }
    
    
    func setUpScrollView() {
//        scrollView.minimumZoomScale = 1.0
//        scrollView.maximumZoomScale = 20.0
////        scrollView.delegate = self //- it is set on the storyboard.
//        scrollView.isUserInteractionEnabled = true
    }
    
    func setUp() {
        let centerY = (labels.frame.height / 2) - 5
        
        //likeButton
        likeButton.center = CGPoint(x: 30, y: centerY)
        
        //share Button
        shareButton.center = CGPoint(x: labels.frame.width - 30, y: centerY)
        
        
        //Sizing
        likesView.frame.size = CGSize(width: 70, height: 20)
        authorView.frame.size = CGSize(width: (labels.frame.width / 2) - 10, height: 20)
        
        //positioning
        likesView.center = CGPoint(x: 90, y: centerY)
        authorView.center = CGPoint(x: labels.frame.width / 2, y: centerY)
        authorView.textAlignment = .center
        
        //adding text TODO get rid of this later
        likesView.text = "15"
        authorView.text = "Yassin Alsahlani"
        
        //add subviews
        labels.addSubview(likeButton)
        labels.addSubview(likesView)
        labels.addSubview(authorView)
        labels.addSubview(shareButton)
        
        lowerView.frame.size.width = view.frame.width
        lowerView.center.x = view.center.x
        
        
        //panning up
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(pan)
    }
    
    
    @objc func handlePan(gesture : UIPanGestureRecognizer) {
        let pan = gesture.translation(in: view).y
        //scrolling up
        if lowerView.center.y + pan > view.center.y {
            panUp(pan)
        }
    }
    
    
    //Takes in a y pan value and scales it, then pans the view accordingly
    fileprivate func panUp(_ value: CGFloat) {
        print("we are panning upward")
        let pan = value * 0.1
        view.center.y += pan
//        lowerView.center.y += pan
        lowerView.frame.size.height -= pan
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        lowerView.frame = view.frame
        print("I am sequing", lowerView.frame)
    }
    
    
    
}

