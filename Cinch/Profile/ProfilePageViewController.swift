//
//  ProfilePageViewController.swift
//  
//
//  Created by Ahmed Gedi on 6/22/19.
//

import UIKit

class ProfilePageViewController: UIViewController {
    var username: String = ""
    var isLocalUser: Bool = true
    
    
    @IBOutlet weak var settingsButton: UIButton!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if username == "" {
            username = String(UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!)
        }
        else {
            settingsButton.isHidden = true
        }
        
        buildProfileViews()
        buildTopProfileGestures()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.set(nil, forKey: defaultsKeys.otherProfile)
    }
    
    @IBAction func toggleSideMenu(_ sender: Any) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard isLocalUser else {
            if segue.identifier == "gemsSegue" {
                let vc = segue.destination as! GemsViewController
                vc.username = username
                vc.isLocalUser = isLocalUser
            }
            if segue.identifier == "foldersFollowingSegue" {
                let vc = segue.destination as! FolderReferenceController
                vc.username = username
                vc.isLocalUser = isLocalUser
            }
            return
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
        
        firstView = FirstProfileHeader().viewWithTag(12)
        
        secondView = SecondProfileHeader().viewWithTag(22)
        topView.addSubview(firstView)
    }
    
    func buildTopProfileGestures() {
        let tapped = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        topView.addGestureRecognizer(tapped)
    }
    
}
