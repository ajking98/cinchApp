//
//  CellSelectedTable.swift
//  Created by Alsahlani, Yassin K on 1/27/20.
//

import UIKit
import AVKit


class CellSelectedTable: UIViewController {
    /*
     Is presented when the user selects a cell from the DiscoverViewController, ProfilePage, or SearchResultsViewController
     Each cell is from CellSelectedController
     */
    
    // MARK: - Data
    
    var content:[String] = []
    var startingIndex = IndexPath(row: 0, section: 0)
    var refreshCell: ((IndexPath)->Void)?
    private let audioSession = AVAudioSession.sharedInstance()
    private var outputVolumeObserve: NSKeyValueObservation?
    private let identifier = "Cell"
    
    
    // MARK: - Views
    
    private let tableView = UITableView(frame: CGRect.zero)

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAudio()
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Nav bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.view.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Tab bar
        navigationController?.tabBarController?.tabBar.isHidden = true
        
        if startingIndex.row == 0 {
            guard let cell = tableView.cellForRow(at: startingIndex) as? CellSelectedCell else { return }
            cell.setup(contentKey: content[0])
            cell.handlePresentProfile = handlePresentProfile(username:)
        }
        else {
            tableView.scrollToRow(at: startingIndex, at: .top, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // Nav bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        
        guard let refreshCell = refreshCell else { return }
        refreshCell(startingIndex)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        // Tab bar
        navigationController?.tabBarController?.tabBar.isHidden = false
        
        guard let cell = tableView.visibleCells[0] as? CellSelectedCell else { return }
        cell.playerLayer.player?.isMuted = true
    }
    
    
    // MARK: - Setup
    
    func setup(content: [String], startingIndex: IndexPath, refreshCell: @escaping((IndexPath) -> Void)) {
        self.content = content
        self.startingIndex = startingIndex
        self.refreshCell = refreshCell
    }
    
    private func setupAudio() {
        do {
            try audioSession.setActive(true)
        } catch {
            print("some error")
        }
        
        outputVolumeObserve = audioSession.observe(\.outputVolume) { (audioSession, changes) in
            guard let cell = self.tableView.visibleCells[0] as? CellSelectedCell else { return }
            let playerLayer = cell.playerLayer
            if isMuted {
                playerLayer.player?.isMuted = false
                isMuted = false
            }
        }
    }
    
    private func setupNavigationBar() {
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .white
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        //Adding swipe to go back functionality to entire screen
        let popGestureRecognizer = self.navigationController!.interactivePopGestureRecognizer!
        if let targets = popGestureRecognizer.value(forKey: "targets") as? NSMutableArray {
            let gestureRecognizer = UIPanGestureRecognizer()
            gestureRecognizer.setValue(targets, forKey: "targets")
            self.view.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .darkBlue
        tableView.isPagingEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CellSelectedCell.self, forCellReuseIdentifier: identifier)
        tableView.contentInsetAdjustmentBehavior = .never
        
        //constraints
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }
    
    
    // MARK: Interaction Handlers
    
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
    
}


// MARK: TableView

extension CellSelectedTable:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CellSelectedCell()
        cell.frame.size = view.frame.size
        cell.backgroundColor = .black
        return cell
    }
    
    ///When the user manually swipes the screen
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index = tableView.indexPathsForVisibleRows![0][1]
        let cell = tableView.cellForRow(at: IndexPath(item: index, section: 0)) as! CellSelectedCell
        
        if cell.contentKey == content[index] { //checks if the user switched to a new cell 
            cell.player.play()
        }
        else {
            cell.setup(contentKey: content[index])
            cell.handlePresentProfile = handlePresentProfile(username:)
        }
        
    }
    
    ///When the app scrolls to the selected index
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        let index = tableView.indexPathsForVisibleRows![0][1]
        let cell = tableView.cellForRow(at: IndexPath(item: index, section: 0)) as! CellSelectedCell
        
        cell.setup(contentKey: content[index])
        cell.handlePresentProfile = handlePresentProfile(username:)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CellSelectedCell else { return }
        cell.handleDisplayDidEnd()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        //Should edit the sound here 
        return false
    }
    
}
