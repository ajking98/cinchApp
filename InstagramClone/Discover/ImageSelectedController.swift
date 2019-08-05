//
//  ImageSelectedController.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 7/5/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

class ImageSelectedController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var items : [Item] = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    @objc func handlePressed(_ tapGesture : UITapGestureRecognizer) {
        print("this is working")
        dismiss(animated: true, completion: nil)
    }
    
}

extension ImageSelectedController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedTableCell", for: indexPath) as! SelectedTablePostCell
        let item = items[indexPath.row]
        cell.postImage.image = UIImage.init(named: item.imageName)
        cell.nameLabel.text = item.author
        cell.viewLabel.text = String(item.likes)
        cell.postImage.layer.cornerRadius = 8.0
        cell.postImage.clipsToBounds = true
        
        return cell
    }
    
    
}
