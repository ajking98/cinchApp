//
//  UpdateScreen.swift
//  Cinch
//
//  Created by Alsahlani, Yassin K on 3/9/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class UpdateScreen: UIViewController {

    let textLabel = UILabel(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup(){
        view.backgroundColor = .lightGray
        print("please update the app")
        title = "Update Needed"
        
        textLabel.text = "Please download the latest version of Cinch to continue"
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        textLabel.font = textLabel.font.withSize(25)
        view.addSubview(textLabel)
        
        //constraints
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textLabel.widthAnchor.constraint(equalToConstant: view.frame.width * 0.9).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: view.frame.height * 0.2).isActive = true
        
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
