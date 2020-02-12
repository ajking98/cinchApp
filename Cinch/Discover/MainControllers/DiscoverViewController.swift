//
/*  DiscoverViewController.swift

        1. Put the search bar in the navigation controller
        2. Set up the Table view
        3. Put the carousel under in the table view header
        4. Design the table cells
        
*/

import UIKit

class DiscoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    //Data
    var width: CGFloat = 0
    var height: CGFloat = 0
    var images:[UIImage] = [] //Images for the top carousel
    var mainHashTags:[String] = []
    let identifier = "Cell"
    
    //Views
    var tableView = UITableView()
    var topCarousel = UIScrollView(frame: CGRect.zero)
    var pageControl = UIPageControl(frame: CGRect.zero)
    var searchBar = SearchBar(frame: CGRect(x: 0, y: 0, width: 310, height: 32.5))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController!.tabBar.layer.borderWidth = 0.9
        self.tabBarController?.tabBar.layer.borderColor = UIColor.lightishGray.cgColor
        fetchData()
        setupData()
        setupSearchBar()
        setupTableView()
        setupCarousel()
        setupTableTagsView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    
    func fetchData() {
        ParentTagStruct().readAdminTags { (tags) in
            print("these are your stuff:", tags)
            self.mainHashTags = tags
            self.tableView.reloadData()
        }
        
        ParentPostStruct().readAdminPosts { (links) in
            for link in links {
                let tempImageView = UIImageView()
                tempImageView.sd_setImage(with: URL(string: link), placeholderImage: UIImage(), completed: nil)
                self.images.append(tempImageView.image!)
            }
            print("this si workng", links)
        }
    }
    
    ///sets up the initial data    
    func setupData() {
        width = view.frame.width
        height = view.frame.height
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    
    ///Builds the design for the search bar within the navigation controller
    func setupSearchBar() {
        searchBar.setup(width)
        searchBar.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.customRed]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
    }
    
    func setupTableView() {
        let tableViewHeight = height - tabBarController!.tabBar.frame.size.height
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: width, height: tableViewHeight))
        tableView.register(TableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .darkBlue
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
    }
    
    
    func setupCarousel() {
        topCarousel.frame = CGRect(x: 0, y: 0, width: width, height: 0.24 * height)
        
        for index in 0..<images.count {
            let xPos = topCarousel.frame.size.width * CGFloat(index)
            let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: xPos, y: 0), size: topCarousel.frame.size))
            imageView.image = images[index]
            topCarousel.addSubview(imageView)
        }
        topCarousel.contentSize = CGSize(width: width * CGFloat(images.count), height: topCarousel.frame.size.height)
           topCarousel.delegate = self
           topCarousel.isPagingEnabled = true
           topCarousel.showsHorizontalScrollIndicator = false
           topCarousel.backgroundColor = .darkBlue
           tableView.tableHeaderView = topCarousel
           
           pageControl.frame = CGRect(x: 0, y: 0, width: 100, height: 24)
           pageControl.center.x = view.center.x
           pageControl.frame.origin.y = (0.23 * height) - pageControl.frame.size.height
           pageControl.numberOfPages = 4
           tableView.addSubview(pageControl)
    }
    
    ///updates the current page for the page control
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = topCarousel.contentOffset.x / topCarousel.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainHashTags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! TableViewCell
      cell.cellHeight = height * 0.242
      cell.cellWidth = tableView.frame.size.width
      cell.viewController = self
        cell.setUp(hashTagTerm: mainHashTags[indexPath.item])
      return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height * 0.242
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        searchBar.endEditing(true)
        return false
    }
    
    
    /*
        SearchBar
     */
     
    var tableTagsView = UITableView()
    var searchTableViewController = SearchTableViewController(style: .plain)

}


extension DiscoverViewController: UISearchBarDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        tableTagsView.alpha = 1
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        tableTagsView.alpha = 0
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            guard let text = searchBar.text else { return }
            nextView(term: text)
        }
        
    }
    
    func nextView(term: String) {
        searchTableViewController.addSearchTerm(term: term)
        tableTagsView.alpha = 0
        searchBar.endEditing(true)
        let vc = SearchResultsViewController()
        vc.initialNavigationController = navigationController
        vc.setup(term: term)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupTableTagsView() {
        view.addSubview(tableTagsView)
        tableTagsView.alpha = 0
        tableTagsView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        searchTableViewController.handleCellSelected = nextView(term:)
        searchTableViewController.searchView = searchBar
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
