//
//  DiscoverController.swift
//  InstagramClone
//
//
/*
 DiscoverPage
 */

import UIKit

private let reuseIdentifier = "Cell"

struct Item {
    var imageName : String
    var likes : Int
    var author : String
}


class DiscoverController: UIViewController {
    
    @IBOutlet weak var segmentControl: UIView!
    @IBOutlet weak var collectionViewIcon: UIImageView!
    @IBOutlet weak var tableViewIcon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    var items : [Item] = [Item]()
    let buttonBar = UIView()
    var tapped = true
    var isRightSegmented = true
    var previousTranslation:CGFloat = 0
    var segmentControlCenter : CGPoint?
    var scrollViewFrame : CGRect?
    var isRefreshing = false
    var loadingIcon = UIImageView()
    var searchBar : SearchBar?
    var isScrolling = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sizeUp()
//        addSearchBar()
        setUpTableView()
        setUpCollectionView()
        setUpCollectionViewItemSizes()
        addContent()
        addGestures()
        addSelectBar(color: UIColor.darkerGreen)
        let tvc = DiscoverTableController()
        tvc.items = items
        
        buildSegmentIcons()
        
        scrollViewFrame = collectionView.frame
        
        
        loadingIcon.loadGif(asset: "loadingIcon")
        loadingIcon.frame.size = CGSize(width: 0, height: 0)
        loadingIcon.center = CGPoint(x: view.center.x, y: collectionView.frame.origin.y + 45)
        view.addSubview(loadingIcon)
        
        normalize(scrollView: collectionView)
        
        collectionView.allowsMultipleSelection = true
        
        setUpNavigation()
    }
    
    func setUpNavigation() {
//        self.navigationController?.navigationBar.barTintColor = UIColor.lightGreen
        self.navigationController?.navigationBar.tintColor = UIColor.darkerGreen
    }
    
    
    func sizeUp() {
        //TODO consider deleting below
        segmentControlCenter = segmentControl.center
        print(segmentControl.center)
    }
    
    
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "PostCard", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setUpCollectionViewItemSizes() {
        let customLayout = DiscoverLayout()
        customLayout.delegate = self
        collectionView.collectionViewLayout = customLayout
    }
    
    
    ///Adds content to discoverpage
    func addContent() {
        items.append(Item(imageName: "f5", likes: 12, author: "something"))
        items.append(Item(imageName: "f2", likes: 13, author: "something"))
        items.append(Item(imageName: "f3", likes: 14, author: "something"))
        items.append(Item(imageName: "f4", likes: 15, author: "something"))
        items.append(Item(imageName: "f5", likes: 16, author: "something"))
        items.append(Item(imageName: "f6", likes: 17, author: "something"))
        items.append(Item(imageName: "f7", likes: 18, author: "something"))
    }
    
    /// Adds Select to Segment Control
    func addSelectBar(color: UIColor) {
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = color
        view.addSubview(buttonBar)
        buttonBar.topAnchor.constraint(equalTo: segmentControl.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 3).isActive = true
        buttonBar.leftAnchor.constraint(equalTo: segmentControl.leftAnchor).isActive = true
        buttonBar.widthAnchor.constraint(equalTo: segmentControl.widthAnchor, multiplier: 1 / 2).isActive = true
    }
    
    func addGestures() {
        let panCollectionViewGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanCollectionView))
        panCollectionViewGesture.delegate = self
        panCollectionViewGesture.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(panCollectionViewGesture)
        
        let panTableViewGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanTableView))
        panTableViewGesture.delegate = self
        tableView.addGestureRecognizer(panTableViewGesture)
        
        segmentControl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSegmentTap(_:))))
    }
    
    
    func refresh(scrollView : UIScrollView) {
        print("offset error")
        isRefreshing = true
        
        
        UIView.animate(withDuration: 0.2) {
            self.loadingIcon.frame.size = CGSize(width: 60, height: 60)
            self.loadingIcon.center = CGPoint(x: self.view.center.x, y: self.collectionView.frame.origin.y + 55)
        }
        
        
        //TODO call the grab images function here
        
        
        //Close refresh icon
        UIView.animate(withDuration: 0.2) {
            self.loadingIcon.frame.size = CGSize(width: 0, height: 0)
            self.loadingIcon.center = CGPoint(x: self.view.center.x, y: self.collectionView.frame.origin.y + 55)
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.loadingIcon.frame.size = CGSize(width: 0, height: 0)
            self.loadingIcon.center = CGPoint(x: self.view.center.x, y: self.collectionView.frame.origin.y + 55)
        }) { (status) in
            self.isRefreshing = false
        }
        
        normalize(scrollView: scrollView)
        print("is refreshing my guy")
        
        // -- or -- //
//        UIView.animate(withDuration: 0.2, animations: {
//            self.loadingIcon.frame.size = CGSize(width: 60, height: 60)
//            self.loadingIcon.center = CGPoint(x: self.view.center.x, y: self.collectionView.frame.origin.y + 55)
//        }) {
//            (status) in
//            //Close refresh icon
//            UIView.animate(withDuration: 0.2) {
//                self.loadingIcon.frame.size = CGSize(width: 0, height: 0)
//                self.loadingIcon.center = CGPoint(x: self.view.center.x, y: self.collectionView.frame.origin.y + 55)
//            }
//            UIView.animate(withDuration: 0.2, animations: {
//                self.loadingIcon.frame.size = CGSize(width: 0, height: 0)
//                self.loadingIcon.center = CGPoint(x: self.view.center.x, y: self.collectionView.frame.origin.y + 55)
//            }) { (status) in
//                self.isRefreshing = false
//            }
//        }
        
    }
    
    
    
    
    func structureFrame(y : CGFloat, height : CGFloat, _ speed : Double){
        UIView.animate(withDuration: speed) {
            //collectionView height and origin
            self.collectionView.frame.size.height = height
            self.collectionView.frame.origin.y = y
            
            //tableView height and origin
            self.tableView.frame.size.height = height
            self.tableView.frame.origin.y = y
        }
    }
    
    
    //animates the view upwards and hides the segment controller
    func unNormalize(scrollView : UIScrollView, _ speed : Double? = nil) {
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            scrollView.center = CGPoint(x: self.view.center.x, y: 100)
            
            guard let scrollViewFrame = self.scrollViewFrame else {
                return
            }
            
            //brings down the segment control
            guard let speed = speed else {
                self.unNormalizeSegmentView(velocity: 0.24)
                self.structureFrame(y: 100, height: scrollViewFrame.height + scrollViewFrame.origin.y - 100, 0.24)
                return
            }
            
            self.unNormalizeSegmentView(velocity: speed)
            self.structureFrame(y: 100, height: scrollViewFrame.height + scrollViewFrame.origin.y - 100, speed)
            
        })
    }
    
    
    
    func unNormalizeSegmentView(velocity : Double){
        UIView.animate(withDuration: velocity) {
            self.segmentControl.center.y = -10 - self.segmentControl.frame.height
            self.buttonBar.center.y = self.segmentControl.frame.origin.y + self.segmentControl.frame.height
            self.searchBar?.center.y = self.segmentControl.frame.origin.y + self.segmentControl.frame.height + 30
        }
    }
    
    
    //Brings the scroll view back down to its original height and brings back the segment control view
    func normalize(scrollView : UIScrollView, _ speed : Double? = nil) {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            scrollView.frame = self.scrollViewFrame!
            
            guard let scrollViewFrame = self.scrollViewFrame else {
                return
            }
            //brings down the segment control
            guard let speed = speed else {
                self.normalizeSegmentView(velocity: 0.24)
                self.structureFrame(y: (scrollViewFrame.origin.y), height: scrollViewFrame.height, 0.24)
                return
            }
            
            self.normalizeSegmentView(velocity: speed)
            self.structureFrame(y: (scrollViewFrame.origin.y), height: scrollViewFrame.height, speed)
            
        }, completion: nil)
    }
    
    
    func normalizeSegmentView(velocity : Double){
        UIView.animate(withDuration: velocity) {
            self.segmentControl.center.y = self.segmentControlCenter!.y
            self.buttonBar.center.y = self.segmentControl.frame.origin.y + self.segmentControl.frame.height
            self.searchBar?.center.y = self.segmentControl.frame.origin.y + self.segmentControl.frame.height + 30
        }
    }
    
    
    
    
    
    
    func buildSegmentIcons() {
        collectionViewIcon.center.x = view.frame.width * 0.23
        tableViewIcon.center.x = (view.frame.width * 0.68)
        handleSegmentControl(true)
    }
    
    
    //if the user taps on the collection view icon while on the collection view, then they scroll to the top
    func bringToTop(scrollView : UIScrollView){
        UIView.animate(withDuration: 0.2) {
            scrollView.contentOffset.y = 0
        }
    }
    
    
    @objc func handleSegmentTap(_ tapGesture : UITapGestureRecognizer) {
        let x = tapGesture.location(in: view).x
        
        if x > view.center.x {
            if isRightSegmented {
                //if the user taps on the collection view icon while on the collection view, then they scroll to the top
                bringToTop(scrollView: tableView)
            }
            summonTableView()
        }
        else {
            if !isRightSegmented {
                bringToTop(scrollView: collectionView)
            }
            summonCollectionView()
        }
    }
    
    
    @objc func handlePanCollectionView(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.view)
        
        gesture.isEnabled = true
        
        switch gesture.state {
        case .began:
            isScrolling = false
            
        case .changed:
            guard abs(translation.x * 2) >= abs(translation.y) else {
                isScrolling = true
                return
            }
            guard !isScrolling else {
                return
            }
            guard abs(translation.x) > abs(translation.y * 10) else {
                return
            }
            //disabling scroll when user is swiping to other view
            if(collectionView.center.x < (view.center.x - 30)){
                collectionView.isScrollEnabled = false
            }
            
            //checking if user is swiping in the wrong direction
            if(gesture.view!.center.x <= view.center.x) {
                translateTables(translation: translation)
            }else {
                //if user is swiping against the wall, then it normalizes the view
                normalize(scrollView: collectionView)
                gesture.isEnabled = false
            }
            gesture.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
        
        case .ended:
            collectionView.isScrollEnabled = true //enables scrolling in the y-axis
            
            //if the user swipes quickly to the left, then they are presented with the table view
            if(isQuickSwipe(velocity: gesture.velocity(in: view).x)){
                let indexPath = collectionView.indexPathsForVisibleItems[0]
                summonTableView(indexPath)
            }
            else {
                //checks to see if the user's gesture traveled far enough to summon the table view
                if tableView.center.x < view.frame.width {
                    let indexPath = collectionView.indexPathsForVisibleItems[0]
                    summonTableView(indexPath)
                    
                } else {
                    summonCollectionView()
                }
            }
        default: break
        }
    }
    
    
    @objc func handlePanTableView(gesture: UIPanGestureRecognizer) {
        gesture.isEnabled = true
        let translation = gesture.translation(in: self.view)
        switch (gesture.state) {
            
            case .began:
                isScrolling = false
            
            case .changed:
                guard abs(translation.x * 2) >= abs(translation.y) else {
                    isScrolling = true
                    return
                }
                guard !isScrolling else {
                    return
                }
                if(tableView.center.x > (view.center.x + 30)){
                    tableView.isScrollEnabled = false
                }
                if(gesture.view!.center.x >= view.center.x) {
                    translateTables(translation: translation)
                }
                else {
                    print("elsing")
                    normalize(scrollView: tableView)
                    gesture.isEnabled = false
                }
                
                gesture.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
            
            case .ended :
                tableView.isScrollEnabled = true
                if(isQuickSwipe(velocity: gesture.velocity(in: view).x)){
                    let indexPath = collectionView.indexPathsForVisibleItems[0]
                    summonCollectionView(indexPath)
                    
                }
                else {
                    if collectionView.center.x < -50 {
                        summonTableView()
                    }
                    else {
                        let indexPath = collectionView.indexPathsForVisibleItems[0]
                        summonCollectionView(indexPath)
                    }
            }
            
            default: break
        }
    }
    
    
    //moves both collection view and table view by the increment given (on the x-axis)
    func translateTables(translation : CGPoint) {
        self.collectionView.center.x += translation.x
        self.tableView.center.x += translation.x
    }
    
    
    //called to animate in the collectionview
    func summonCollectionView(_ indexPath : IndexPath = IndexPath(item: 0, section: 0)) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
            self.handleSegmentControl(true)
            self.collectionView.center.x = self.view.center.x
            self.tableView.center.x = self.view.center.x + self.view.frame.width
            self.buttonBar.frame.origin.x = 20
            
            
            //scrolls to index
            if (indexPath != IndexPath(item: 0, section: 0)){
                self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
            }
        }, completion: nil)
    }
    
    
    //called to animate in the collectionview
    func summonTableView(_ indexPath : IndexPath = IndexPath(item: 0, section: 0) ) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
            self.handleSegmentControl(false)
            self.collectionView.center.x = self.view.center.x - self.view.frame.width
            self.tableView.center.x = self.view.center.x
            self.buttonBar.frame.origin.x = self.view.center.x
            
            
            //scrolls to the index
            if (indexPath != IndexPath(item: 0, section: 0)){
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            
        }, completion: nil)
    }
    
    
    
    fileprivate func handleSegmentControl(_ condition : Bool) {
        if(isRightSegmented && condition){
            self.tableViewIcon.image = UIImage(named: "tableIconBlack")
            self.collectionViewIcon.image = UIImage(named: "collectionIconGreen")
            self.collectionViewIcon.center.y -= 5
            self.tableViewIcon.center.y += 5
            self.collectionViewIcon.frame.size = CGSize(width: 30, height: 30)
            self.tableViewIcon.frame.size = CGSize(width: 25, height: 25)
            isRightSegmented = false
        }
        else if(!isRightSegmented && !condition) {
            self.tableViewIcon.image = UIImage(named: "tableIconGreen")
            self.collectionViewIcon.image = UIImage(named: "collectionIconBlack")
            self.collectionViewIcon.center.y += 5
            self.tableViewIcon.center.y -= 5
            self.collectionViewIcon.frame.size = CGSize(width: 25, height: 25)
            self.tableViewIcon.frame.size = CGSize(width: 30, height: 30)
            isRightSegmented = true
        }
    }
    
}







extension DiscoverController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCard
        cell.buildPostCard(item: items[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ImageSelectedController") as! ImageSelectedController
        for index in indexPath.row...(items.count - 1) {
            vc.items.append(items[index])
            vc.discoverController = self
        }
        var item = items[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}








extension DiscoverController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableViewPostCell
        let item = items[indexPath.row]
        cell.postImage.image = UIImage.init(named: item.imageName)
//        cell.nameLabel.text = item.author
//        cell.viewLabel.text = String(item.likes)
        cell.postImage.layer.cornerRadius = 8.0
        cell.postImage.clipsToBounds = true
        
        // Configure the cell...
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ImageSelectedController") as! ImageSelectedController
        for index in indexPath.row...(items.count - 1) {
            vc.items.append(items[index])
        }
        var item = items[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension DiscoverController : DiscoverLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        let cellSize = UIImage(named: items[indexPath.item].imageName)!.size
        return cellSize
    }
}

extension DiscoverController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
