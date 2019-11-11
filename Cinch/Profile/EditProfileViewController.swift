//
//  EditProfileViewController.swift
//  Cinch
//
//  Created by Ahmed Gedi on 11/11/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var bioText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestures()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeAction(_ sender: Any) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
            self.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }
    
    func addGestures() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closeAction(_:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(swipeDown)
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
