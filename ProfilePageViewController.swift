//
//  ProfilePageViewController.swift
//  
//
//  Created by Ahmed Gedi on 6/22/19.
//

import UIKit

class ProfilePageViewController: UIViewController {
    
//    @IBOutlet weak var fullName: UILabel!
//    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var customSegmentedControl: UISegmentedControl!
    var firstView: UIView!
    var secondView: UIView!
    var reactionView: UIView!
    var gemView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildProfileViews()
        buildSegmentedFolderControl()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        topView.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        topView.addGestureRecognizer(swipeRight)

//        profileImage.layer.cornerRadius = 30
//        profileImage.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func toggleSideMenu(_ sender: Any) {
        print("Toggle Side Menu")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Toggle Side Menu"), object: nil)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right {
            print("Swipe Right")
            secondView.removeFromSuperview()
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.topView.addSubview(self.firstView)
            }, completion: nil)
//            topView.addSubview(firstView)
//            topView.bringSubviewToFront(firstView)
            pageControl.currentPage = 0
            
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            print("Swipe Left")
            firstView.removeFromSuperview()
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.topView.addSubview(self.secondView)
            }, completion: nil)
//            topView.bringSubviewToFront(secondView)
            pageControl.currentPage = 1
        }
    }
    
    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            customSegmentedControl.tintColor = UIColor(red: 1/255.0, green: 209/255.0, blue: 151/255.0, alpha: 1.0)
            viewContainer.bringSubviewToFront(gemView)
        case 1:
            customSegmentedControl.tintColor = UIColor(red: 1/255.0, green: 151/255.0, blue: 209/255.0, alpha: 1.0)
            viewContainer.bringSubviewToFront(reactionView)
        default:
            break
        }
    }
    
    func buildSegmentedFolderControl() {
        reactionView = ReactionsViewController().view
        gemView = GemsViewController().view
        viewContainer.addSubview(reactionView)
        viewContainer.addSubview(gemView)
    }
    
    func buildProfileViews() {
        firstView = FirstProfileHeader().viewWithTag(12) as UIView?
        secondView = SecondProfileHeader().viewWithTag(22) as UIView?
//        topView.addSubview(secondView)
        topView.addSubview(firstView)
    }
    
}
