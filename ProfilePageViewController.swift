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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var customSegmentedControl: UISegmentedControl!
    var reactionView: UIView!
    var gemView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildSegmentedFolderControl()
        profileImage.layer.cornerRadius = 30
        profileImage.clipsToBounds = true
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            customSegmentedControl.tintColor = UIColor(red: 1/255.0, green: 209/255.0, blue: 151/255.0, alpha: 1.0)
            viewContainer.bringSubviewToFront(reactionView)
        case 1:
            customSegmentedControl.tintColor = UIColor(red: 1/255.0, green: 151/255.0, blue: 209/255.0, alpha: 1.0)
            viewContainer.bringSubviewToFront(gemView)
        default:
            break
        }
    }
    
    func buildSegmentedFolderControl() {
        reactionView = ReactionsViewController().view
        gemView = GemsViewController().view
        viewContainer.addSubview(gemView)
        viewContainer.addSubview(reactionView)
    }
    
}
