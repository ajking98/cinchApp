//
//  ProfileSettingsController.swift
//  Cinch
//
//  Created by Gedi, Ahmed M on 8/7/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//
import UIKit

class ProfileSettingsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closeAction(_:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(swipeDown)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeAction(_ sender: Any) {
        print("Close")
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
