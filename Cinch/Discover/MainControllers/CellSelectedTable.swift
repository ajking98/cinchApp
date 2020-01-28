//
//  CellSelectedTable.swift
/*
    Is presented when the user selects a cell from the DiscoverViewController
    Each cell is from CellSelectedController
 */
//  Created by Alsahlani, Yassin K on 1/27/20.
//

import UIKit

class CellSelectedTable: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let tableView = UITableView(frame: CGRect.zero)
    let identifier = "Cell"
    
    let backIcon = UIImageView(image: UIImage(named: "backIcon-white"))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupBackIcon()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .darkBlue
        tableView.isPagingEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CellSelectedCell.self, forCellReuseIdentifier: identifier)
        tableView.contentInsetAdjustmentBehavior = .never
        
        
        //constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    //back icon
    func setupBackIcon(){
        view.addSubview(backIcon)
        
        //constraints
        backIcon.translatesAutoresizingMaskIntoConstraints = false
        backIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 17.5).isActive = true
        backIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.06 * view.frame.height).isActive = true
        backIcon.heightAnchor.constraint(equalToConstant: 32).isActive = true
        backIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        backIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack(_:))))
        backIcon.isUserInteractionEnabled = true
        
    }
    
    
    @objc func goBack(_ sender: UITapGestureRecognizer? = nil) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! CellSelectedCell
        cell.frame.size = view.frame.size
        cell.setup()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    

}
