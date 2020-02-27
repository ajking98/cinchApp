//
//  CellSelectedTable.swift
/*
    Is presented when the user selects a cell from the DiscoverViewController, FolderSelectedController, or SearchResultsViewController
    Each cell is from CellSelectedController
 */
//  Created by Alsahlani, Yassin K on 1/27/20.
//

import UIKit

class CellSelectedTable: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    //Data given by the presenting VC
    var content:[String] = []
    var startingIndex = IndexPath(row: 0, section: 0)
    
    let tableView = UITableView(frame: CGRect.zero)
    let identifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //making the navigation bar invisible
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.view.backgroundColor = .clear
        
        //hiding tab bar
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.scrollToRow(at: startingIndex, at: .top, animated: true)
    }
    
    func setupNavigationBar() {
        //Enables swiping back
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        //making the navigation bar invisible
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        //back button
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backIcon-white"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        let leftNavItem = UIBarButtonItem(customView: backButton)
        navigationItem.setLeftBarButton(leftNavItem, animated: false)
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
    
    @objc func goBack(_ sender: UITapGestureRecognizer? = nil) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func handlePresentProfile(username: String){
        let vc = ProfileViewController()
        vc.isUser = false
        vc.username = username
        startingIndex = tableView.indexPathsForVisibleRows![0]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! CellSelectedCell
        cell.frame.size = view.frame.size
        cell.setup(link: content[indexPath.row])
        cell.handlePresentProfile = handlePresentProfile(username:)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CellSelectedCell else { return }
        cell.playerLayer.player?.isMuted = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        guard let cell = tableView.visibleCells[0] as? CellSelectedCell else { return }
        cell.playerLayer.player?.isMuted = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        //Should edit the sound here 
        return false
    }

}
