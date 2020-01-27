//
/*  DiscoverViewController.swift

        1. Put the search bar in the navigation controller
        2. Set up the Table view
        3. Put the carousel under in the table view header
*/

import UIKit

class DiscoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    ///width of screen
    var width: CGFloat = 0
    ///height of screen
    var height: CGFloat = 0
    
    //Search
    var searchBar = SearchBar(frame: CGRect(x: 0, y: 0, width: 310, height: 32.5))
    
    //Table view
    var tableView: UITableView?
    let identifier = "Cell"
    
    //Carousel
    var topCarousel = UIScrollView(frame: CGRect.zero)
    var pageControl = UIPageControl(frame: CGRect.zero)
    var images = ["A", "B", "C", "D"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setupSearchBar()
        setupTableView()
        setupCarousel()
    }
    
    ///sets up the initial data    
    func setupData() {
        width = view.frame.width
        height = view.frame.height
    }
    
    
    ///Builds the design for the search bar within the navigation controller
    func setupSearchBar() {
        searchBar.setup(width)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
    
    func setupTableView() {
        let tableViewHeight = height - tabBarController!.tabBar.frame.size.height
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: width, height: tableViewHeight))
        tableView?.register(TableViewCell.self, forCellReuseIdentifier: identifier)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = .darkBlue
        tableView?.showsVerticalScrollIndicator = false
        view.addSubview(tableView!)
    }
    
    
    func setupCarousel() {
        topCarousel.frame = CGRect(x: 0, y: 0, width: width, height: 0.24 * height)
        
        for index in 0..<images.count {
            let xPos = topCarousel.frame.size.width * CGFloat(index)
            let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: xPos, y: 0), size: topCarousel.frame.size))
            imageView.image = UIImage(named: images[index])
            topCarousel.addSubview(imageView)
        }
        topCarousel.contentSize = CGSize(width: width * CGFloat(images.count), height: topCarousel.frame.size.height)
           topCarousel.delegate = self
           topCarousel.isPagingEnabled = true
           topCarousel.showsHorizontalScrollIndicator = false
           topCarousel.backgroundColor = .darkBlue
           tableView?.tableHeaderView = topCarousel
           
           pageControl.frame = CGRect(x: 0, y: 0, width: 100, height: 24)
           pageControl.center.x = view.center.x
           pageControl.frame.origin.y = (0.23 * height) - pageControl.frame.size.height
           pageControl.numberOfPages = 4
           tableView!.addSubview(pageControl)
    }
    
    ///updates the current page for the page control
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = topCarousel.contentOffset.x / topCarousel.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 //TODO change this
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! TableViewCell
      cell.cellHeight = height * 0.242
      cell.cellWidth = tableView.frame.size.width
      cell.viewController = self
      cell.setUp()
      return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height * 0.242
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        searchBar.endEditing(true)
        return false
    }
     

}
