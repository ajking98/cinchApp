//
//  DiscoverController.swift
//  Cinch
//
//
/*
 DiscoverPage
 */

import UIKit
import AVKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import XLActionController

private let reuseIdentifier = "Cell"
private let reuseIdentifierTable = "Cell2"

struct Item {
    var imageName : String
    var likes : Int
    var author : String
}

class DiscoverController: UIViewController, transferDelegate {
    func handleAlert(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func presentContent(content: SpotifyActionController) {
        present(content, animated: true, completion: nil)
    }
    
    var something: String = "This is a test"
    
    
    @IBOutlet weak var segmentControl: UIView!
    @IBOutlet weak var collectionViewIcon: UIImageView!
    @IBOutlet weak var tableViewIcon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let buttonBar = UIView()
    var tapped = true
    var isRightSegmented = true
    var previousTranslation:CGFloat = 0
    var segmentControlCenter : CGPoint?
    var scrollViewFrame : CGRect?
    var isRefreshing = false
    var loadingIcon = UIImageView()
    var searchBar : SearchBar?
    var isPrimaryViewController = true
    
    //firebase
    var dbRef: DatabaseReference!
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference().child("posts")
        if isPrimaryViewController {
            fetchContent()
        }
        sizeUp()
        setUpTableView()
        setUpCollectionView()
        setUpCollectionViewItemSizes()
        addGestures()
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
    
    
    
    ///Updates the content array with values from the DB
    //TODO this is not updating the collectionView, it is only updating the tableview
    func fetchContent(_ completion: ((Bool) -> Void)? = nil) {
        print("This is being called")
        let username = String(UserDefaults.standard.string(forKey: defaultsKeys.usernameKey)!)
        
        ParentPostStruct().readMultiplePosts(limit: 30) { (postArray) in
            print("this is something")
            self.posts = postArray
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
        
        
        //TODO eventually we would want to emplement the code below
//        UserStruct().readNewContent(user: username) { (newContent) in
//            for (_, value) in newContent {
//
//                print("we are atleast going here2")
//                let indexPath = IndexPath(row: self.posts.count, section: 0)
//                //TODO this creates a post using the link and uses static data in contstructor, this should instead get the data from the posts section in the database
//
//                let post = Post(isImage: true, numberOfLikes: 0, postOwner: "", likedBy: ["someone"], dateCreated: Date().timeIntervalSince1970, tags: ["nothing"], link: value)
//                PostStruct().readPostOwner(post: value, completion: { (owner) in
//                    post.postOwner = owner;
//                })
//                if self.posts.contains(where: { (selectedPost) -> Bool in
//                    return selectedPost.link == post.link
//                }) { continue }
//                self.posts.append(post)
//                self.collectionView.reloadData()
//                self.tableView.insertRows(at: [indexPath], with: .right)
//            }
//            guard let completion = completion else { return }
//            completion(true)
//        }
//        UserStruct().readSuggestedContent(user: username) { (suggestedContent) in
//            for (_, value) in suggestedContent {
//                let indexPath = IndexPath(row: self.posts.count, section: 0)
//                //TODO this creates a post using the link and uses static data in contstructor, this should instead get the data from the posts section in the database
//
//                let post = Post(isImage: true, numberOfLikes: 0, postOwner: "", likedBy: ["someone"], dateCreated: Date().timeIntervalSince1970, tags: ["nothing"], link: value)
//
//                PostStruct().readPostOwner(post: value, completion: { (owner) in
//                    post.postOwner = owner;
//                })
//
//                if self.posts.contains(where: { (selectedPost) -> Bool in
//                    return selectedPost.link == post.link
//                }) { continue }
//                self.posts.append(post)
//                self.collectionView.reloadData()
//                self.tableView.insertRows(at: [indexPath], with: .right)
//            }
//            guard let completion = completion else { return }
//            completion(true)
//        }
    }
    
    func setUpNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor.darkerGreen
    }
    
    
    func sizeUp() {
        //TODO consider deleting below
        segmentControlCenter = segmentControl.center
    }
    
    
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "PostCard", bundle: nil)
        let nib2 = UINib(nibName: "TablePostCard", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        tableView.register(nib2, forCellReuseIdentifier: reuseIdentifierTable)
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
    
    /// Adds Select to Segment Control
    func addSelectBar(color: UIColor) {
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = color
        buttonBar.frame.size = CGSize(width: view.frame.width * 0.40, height: 3)
        buttonBar.frame.origin.y = segmentControl.frame.height
        segmentControl.addSubview(buttonBar)
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
        isRefreshing = true
        
//
//        UIView.animate(withDuration: 0.2) {
//            self.loadingIcon.frame.size = CGSize(width: 60, height: 60)
//            self.loadingIcon.center = CGPoint(x: self.view.center.x, y: self.collectionView.frame.origin.y + 55)
//        }
        print("this is the frame for the loadingicon", loadingIcon.frame)
        
        
        //TODO call the fetch content function here
//        fetchContent { (isCompleted) in
//            print("we have fetched the new content:", isCompleted)
//
//            //Close refresh icon
//            UIView.animate(withDuration: 0.2, animations: {
//                self.loadingIcon.frame.size = CGSize(width: 0, height: 0)
//                self.loadingIcon.center = CGPoint(x: self.view.center.x, y: self.collectionView.frame.origin.y + 55)
//            }) { (status) in
//                self.isRefreshing = false
//            }
//        }
        
        
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
    
    
    ///animates the view upwards and hides the segment controller
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
            self.buttonBar.center.y = self.segmentControl.frame.height
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
            self.buttonBar.center.y = self.segmentControl.frame.height
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
            handleSegmentControl(false) //summons the table view
        }
        else {
            handleSegmentControl(true) //summons the collectionview
        }
    }
    
    
    @objc func handlePanCollectionView(gesture: UIPanGestureRecognizer) {
        gesture.isEnabled = true
        switch gesture.state {
        case .changed:
            
            //checking if user is swiping in the wrong direction
            //if user is swiping against the wall, then it normalizes the view
            normalize(scrollView: collectionView)
            gesture.isEnabled = false
            gesture.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
            
        default: break
        }
    }
    
    
    @objc func handlePanTableView(gesture: UIPanGestureRecognizer) {
        gesture.isEnabled = true
        switch gesture.state {
        case .changed:
            
            //checking if user is swiping in the wrong direction
            //if user is swiping against the wall, then it normalizes the view
            normalize(scrollView: tableView)
            gesture.isEnabled = false
            gesture.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
            
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
            self.collectionView.center.x = self.view.center.x
            self.tableView.center.x = self.view.center.x + self.view.frame.width
            
            //scrolls to index
            if (indexPath != IndexPath(item: 0, section: 0)){
                self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
            }
        }, completion: nil)
    }
    
    
    //called to animate in the collectionview
    func summonTableView(_ indexPath : IndexPath = IndexPath(item: 0, section: 0) ) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
            self.collectionView.center.x = self.view.center.x - self.view.frame.width
            self.tableView.center.x = self.view.center.x
            
            //scrolls to the index
            if (indexPath != IndexPath(item: 0, section: 0)){
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            
        }, completion: nil)
    }
    
    
    ///handles the action when the user taps on either the collectionViewicon or the tableViewicon
    fileprivate func handleSegmentControl(_ condition : Bool) {
        if(condition){ //sets up the CollectionView
            if isRightSegmented {
                bringToTop(scrollView: collectionView)
                return
            }
            self.tableViewIcon.image = UIImage(named: "tableIconBlack")
            self.collectionViewIcon.image = UIImage(named: "collectionIconGreen")
            UIView.animate(withDuration: 0.2) {
                self.collectionViewIcon.center.y -= 5
                self.tableViewIcon.center.y += 5
                self.collectionViewIcon.frame.size = CGSize(width: 30, height: 30)
                self.tableViewIcon.frame.size = CGSize(width: 25, height: 25)
                self.buttonBar.frame.origin.x = 0
            }
            summonCollectionView()
            isRightSegmented = true
        }
        else { //sets up the tableview
            if !isRightSegmented {
                bringToTop(scrollView: tableView)
                return
            }
            UIView.animate(withDuration: 0.2) {
                self.tableViewIcon.image = UIImage(named: "tableIconGreen")
                self.collectionViewIcon.image = UIImage(named: "collectionIconBlack")
                self.collectionViewIcon.center.y += 5
                self.tableViewIcon.center.y -= 5
                self.collectionViewIcon.frame.size = CGSize(width: 25, height: 25)
                self.tableViewIcon.frame.size = CGSize(width: 30, height: 30)
                self.buttonBar.frame.origin.x = self.view.center.x
            }
            summonTableView()
            isRightSegmented = false
        }
    }
}




extension DiscoverController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCard
        let current = posts[indexPath.row]
        cell.delegate = self
        cell.buildPostCard(item: current)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchZoomViewController") as! SearchZoomViewController
        guard let link = posts[indexPath.item].link else { return }
        let url = URL(string: link)
        vc.post = posts[indexPath.item]
        if checkIfVideo(link: link) {
            vc.isImage = false
            vc.link = link
        } else {
            let imageView = UIImageView()
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
            vc.image = imageView.image!
        }
        present(vc, animated: true, completion: nil)
    }
    
}


extension DiscoverController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Todo change the string literal to a variable and get rid of the TablePostCard.xib
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TablePostCard
        let currentPost = posts[indexPath.row]
        cell.delegate = self
        cell.buildPostCard(link: currentPost.link!)
        return cell
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchZoomViewController") as! SearchZoomViewController
        let link = posts[indexPath.item].link
        let url = URL(string: link!)
        vc.post = posts[indexPath.item]
        if link!.contains("mp4") {
            vc.isImage = false
            vc.link = link!
        } else {
            let imageView = UIImageView()
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
            vc.image = imageView.image!
        }
        present(vc, animated: true, completion: nil)
    }

}


extension DiscoverController : DiscoverLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        var cellSize = CGSize()
        if(posts[indexPath.item].link!.contains("mp4")) {
            cellSize = CGSize(width: 300, height: 370)
        } else {
            cellSize = CGSize(width: 300, height: 370)
        }
        
        return cellSize
    }
}


//Lets the controller recogonize multiple gestures as they occur
extension DiscoverController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
