//
/*  DiscoverViewController.swift
 
 */
import UIKit

class DiscoverViewController: UIViewController {
    /*
     First view user sees when opening app
     */
    
    // MARK: Data
    var width: CGFloat = 0
    var height: CGFloat = 0
    let identifier = "Cell"
    
    // MARK: Views
    var images:[UIImage] = [] //Images for the top carousel
    var imageLinks:[String] = [] //Links for the images on the top carousel
    var mainHashTags:[String] = []
    var tableView = UITableView()
    var topCarousel = UIScrollView(frame: CGRect.zero)
    var pageControl = UIPageControl(frame: CGRect.zero)
    var searchBar = SearchBar(frame: CGRect(x: 0, y: 0, width: 310, height: 32.5))
    var tableTagsView = UITableView()
    var priorityTagsView = UITableView()
    var searchTableViewController = SearchTableViewController(style: .plain)
    var searchPriorityViewController = SearchTableViewController(style: .plain)
    
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Nav bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .systemBackground
        
        // Tab bar
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: Setup
    
    func setup() {
        fetchData()
        setupData()
        setupSearchBar()
        setupTableView()
        //        setupCarousel()
        setupTableTagsView()
        setupPriorityTagsView()
    }
    
    
    func fetchData() {
        guard let username = UserDefaults.standard.string(forKey: defaultsKeys.usernameKey) else { return }
        
        //Check version
        ParentStruct().readVersion { (latestVersion) in
            UserStruct().readVersion(username: username, { (currentVersion) in
                if (currentVersion * 10).rounded(.down) < (latestVersion * 10).rounded(.down) {
                    let vc = UpdateScreen()
                    let navController = UINavigationController(rootViewController: vc)
                    navController.modalPresentationStyle = .fullScreen
                    self.present(navController, animated: true, completion: nil)
                }
            }) {
                UserStruct().updateVersion(username: username, version: latestVersion)
            }
        }
        
        
        //TODO: This should be calling a Heroku endpoint
        ParentTagStruct().readAdminTags { (tags) in
            tags.forEach { (hashTagTerm) in
                self.mainHashTags.append(hashTagTerm.lowercased().capitalizeFirstLetter())
            }
            self.tableView.reloadData()
        }
    }
    
    func setupData() {
        width = view.frame.width
        height = view.frame.height
    }
    
    func setupSearchBar() {
        searchBar.setup(width)
        searchBar.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.customRed]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.register(DiscoverCell.self, forCellReuseIdentifier: identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .darkBlue
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        //constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    
    // MARK: Interaction Handlers
    
    @objc func handleCarouselTapped() {
        if pageControl.currentPage == 0 { return }
        let vc = CellSelectedTable()
        vc.content = self.imageLinks
        vc.modalPresentationStyle = .fullScreen
        vc.startingIndex = IndexPath(row: pageControl.currentPage - 1, section: 0)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleGoToResult(str: String) {
        let vc = SearchResultsViewController()
        vc.initialNavigationController = navigationController
        vc.setup(term: str)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


// MARK: TableView
extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainHashTags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DiscoverCell
        let cellTerm = mainHashTags[indexPath.item]
        let cellSize = CGSize(width: tableView.frame.size.width, height: height * 0.242)
        cell.setUp(hashTagTerm: cellTerm, cellSize: cellSize)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height * 0.25
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        searchBar.endEditing(true)
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleGoToResult(str: mainHashTags[indexPath.row])
    }
}


// MARK: Searchbar
extension DiscoverViewController: UISearchBarDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        guard let textCount = searchBar.text?.count else {
            return
        }
        
        if textCount == 0 {
            searchTableViewController.setup()
            searchPriorityViewController.tags = mainHashTags
            priorityTagsView.reloadData()
            tableTagsView.alpha = 0
            priorityTagsView.alpha = 1
        }
        else {
            tableTagsView.alpha = 1
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        tableTagsView.alpha = 0
        priorityTagsView.alpha = 0
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            guard let text = searchBar.text else { return }
            nextView(term: text)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTableViewController.handleSearching(searchText: searchText.lowercased())
        
        if searchText.count == 0 {
            tableTagsView.alpha = 0
            priorityTagsView.alpha = 1
        }
        else {
            priorityTagsView.alpha = 0
            tableTagsView.alpha = 1
        }
    }
}


// MARK: - Setup For Search
extension DiscoverViewController {
    
    //YASSIN TODO: Start here
    func nextView(term: String) {
        tableTagsView.alpha = 0
        searchBar.endEditing(true)
        let vc = SearchResultsViewController()
        vc.initialNavigationController = navigationController
        vc.setup(term: term)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///Builds the UI for the priority tags
    func setupPriorityTagsView() {
        view.addSubview(priorityTagsView)
        priorityTagsView.alpha = 0
        priorityTagsView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        searchPriorityViewController.handleCellSelected = nextView(term:)
        priorityTagsView.dataSource = searchPriorityViewController
        priorityTagsView.delegate = searchPriorityViewController
        priorityTagsView.separatorStyle = .none
        
        priorityTagsView.translatesAutoresizingMaskIntoConstraints = false
        priorityTagsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        priorityTagsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        priorityTagsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        priorityTagsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    func setupTableTagsView() {
        view.addSubview(tableTagsView)
        tableTagsView.alpha = 0
        tableTagsView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        searchTableViewController.handleCellSelected = nextView(term:)
        tableTagsView.dataSource = searchTableViewController
        tableTagsView.delegate = searchTableViewController
        tableTagsView.separatorStyle = .none
        
        //constraints
        tableTagsView.translatesAutoresizingMaskIntoConstraints = false
        tableTagsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableTagsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableTagsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableTagsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
}
