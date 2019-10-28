//
//  ProfilePageViewController.swift
//  
//
//  Created by Ahmed Gedi on 6/22/19.
//

import UIKit

class ProfilePageViewController: UIViewController {
    
    @IBOutlet weak var numberOfFollowersLabel: UILabel!
    @IBOutlet weak var numberOfFollowingsLabel: UILabel!
    @IBOutlet weak var numberOfGemsLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var customSegmentedControl: UISegmentedControl!
    var firstView: UIView!
    var secondView: UIView!
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    var profileViewTapped = false
    var username : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if username == nil {
            username = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)
        }
        
        buildProfileViews()
        buildTopProfileGestures()
    }
    
    @IBAction func toggleSideMenu(_ sender: Any) {
        print("Toggle Side Menu")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Toggle Side Menu"), object: nil)
    }
    
    @objc func handleGesture(gesture: UITapGestureRecognizer) -> Void {
        if profileViewTapped == true {
            print("Tapped")
            secondView.removeFromSuperview()
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.topView.addSubview(self.firstView)
            }, completion: nil)
            
            pageControl.currentPage = 0
            profileViewTapped = false
        }
        else {
            print("Tapped2")
            firstView.removeFromSuperview()
            UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                self.topView.addSubview(self.secondView)
            }, completion: nil)
            pageControl.currentPage = 1
            profileViewTapped = true
        }
        
    }
    
    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            customSegmentedControl.tintColor = UIColor(red: 1/255.0, green: 209/255.0, blue: 151/255.0, alpha: 1.0)
            viewOne.alpha = 1
            viewTwo.alpha = 0
        case 1:
            customSegmentedControl.tintColor = UIColor(red: 1/255.0, green: 151/255.0, blue: 209/255.0, alpha: 1.0)
            viewOne.alpha = 0
            viewTwo.alpha = 1
        default:
            break
        }
    }
    
    func buildProfileViews() {
        UserStruct().readFollowers(user: username) { (followers) in
            self.numberOfFollowersLabel.text = String(followers.count)
        }
        
        UserStruct().readFollowing(user: username) { (followings) in
            self.numberOfFollowingsLabel.text = String(followings.count)
        }
        
        //TODO implement read number of Gems - Should be a stored value in the DB 
//        UserStruct().read
        
        firstView = FirstProfileHeader().viewWithTag(12) as UIView?
        secondView = SecondProfileHeader().viewWithTag(22) as UIView?
        topView.addSubview(firstView)
    }
    
    func buildTopProfileGestures() {
        let tapped = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        topView.addGestureRecognizer(tapped)
    }
    
}
