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
    @IBOutlet weak var collectionViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    var items : [Item] = [Item]()
    let buttonBar = UIView()
    var tapped = true
    var isRightSegmented = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printChecks()
        
        addSearchBar()
        setUpTableView()
        setUpCollectionView()
        setUpCollectionViewItemSizes()
        addContent()
        addGestures()
        addSelectBar(color: UIColor.darkerGreen)
        let tvc = DiscoverTableController()
        tvc.items = items
        
        buildSegmentIcons()
    }
    
    func buildSegmentIcons() {
        collectionViewIcon.center.x = view.frame.width * 0.23
        tableViewIcon.center.x = (view.frame.width * 0.68)
        handleSegmentControl(true)
    }
    
    func addSearchBar() {
        let frame = collectionView.frame
        var searchBar = SearchBar(frame: CGRect(x: 0, y: 0, width: frame.width * 0.88, height: 33))
        searchBar.center = CGPoint(x: view.center.x, y: collectionView.frame.origin.y + 12)
        let tapped = UITapGestureRecognizer(target: searchBar, action: #selector(searchBar.revertToNormal))
        tapped.cancelsTouchesInView = false
        view.addGestureRecognizer(tapped)
        searchBar.backgroundColor = .white
        view.addSubview(searchBar)
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
        
        let panTableViewGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTableViewPan))
        panTableViewGesture.delegate = self
        tableView.addGestureRecognizer(panTableViewGesture)
        
        segmentControl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSegmentTap(_:))))
    }
    
//    func setUserDefaults() {
//        let defaults = UserDefaults(suiteName: "group.InstagramClone.messages")
//        defaults?.set(objectImages, forKey: "testImages")
//    }
    
    func printChecks() {
//        print("Collection View \(self.collectionView.center.x)" )
//        print("Table View \(self.tableView.center.x)" )
    }
    
    @objc func handleSegmentTap(_ tapGesture : UITapGestureRecognizer) {
        let x = tapGesture.location(in: view).x
        
        if x > view.center.x {
            summonTableView()
        }
        else {
            summonCollectionView()
        }
    }
    
    @objc func handlePanCollectionView(gesture: UIPanGestureRecognizer) {
        gesture.isEnabled = true
        switch gesture.state {
        case .began, .changed:
            let translation = gesture.translation(in: self.view)
            if(gesture.view!.center.x <= view.center.x) {
                translateTables(translation: translation)
            }else {
                UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
                    self.collectionView.center = CGPoint(x: 207, y: gesture.view!.center.y)
                    self.buttonBar.frame.origin.x = 20
                    gesture.isEnabled = false
                }, completion: nil)
            }
            
            gesture.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
        
        case .ended:
            if(isQuickSwipe(velocity: gesture.velocity(in: view).x)){
                summonTableView()
            }
            if tableView.center.x < 400 {
                summonTableView()
                
            } else {
                summonCollectionView()
            }
        default:
            print("defaulted")
        }
    }
    
    @objc func handleTableViewPan(gesture: UIPanGestureRecognizer) {
        gesture.isEnabled = true
        switch (gesture.state) {
            
            case .began, .changed:
                print("changing")
                let translation = gesture.translation(in: self.view)
                if(gesture.view!.center.x >= view.center.x) {
                    translateTables(translation: translation)
                }
                else {
                    UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
                        self.tableView.center = CGPoint(x: 207, y: gesture.view!.center.y)
                        self.buttonBar.frame.origin.x = 207
                        gesture.isEnabled = false
                    }, completion: nil)
                }
                
                gesture.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
            
            case .ended :
                if(isQuickSwipe(velocity: gesture.velocity(in: view).x)){
                    summonCollectionView()
                }
                if collectionView.center.x < -50 {
                    summonTableView()
                }
                else {
                    summonCollectionView()
                }
            
            default:
                print("defaulted")
        }
    }
    
    func translateTables(translation : CGPoint) {
        self.collectionView.center.x += translation.x
        self.tableView.center.x += translation.x
    }
    
    func summonCollectionView() {
        print("summoning collectionview")
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
            self.handleSegmentControl(true)
            self.collectionView.center.x = 207
            self.tableView.center.x = 621
            self.buttonBar.frame.origin.x = 20
        }, completion: nil)
    }
    
    
    func summonTableView() {
        print("table view")
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
            self.handleSegmentControl(false)
            self.collectionView.center.x = -207
            self.tableView.center.x = 207
            self.buttonBar.frame.origin.x = 207
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
//        cell.createGestures(target: self, action: #selector(handlePressed))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection Selected Row \(indexPath.row)")
        let vc = storyboard?.instantiateViewController(withIdentifier: "ImageSelectedController") as! ImageSelectedController
        for index in indexPath.row...(items.count - 1) {
            vc.items.append(items[index])
        }
        var item = items[indexPath.row]
        //        vc.imageName = UIImage.init(named: item.imageName)!
        //        vc.nameLabel.text = item.author
        //        vc.likesLabel.text = String(item.likes)
        //
        //        print(UIImage.init(named: items[indexPath.row].imageName)!)
        //        //        vc.setupView(image: UIImage.init(named: items[indexPath.row].imageName)!)
        //        self.present(vc, animated: true, completion: nil)
        //        //        let vc = ImageSelectedController()
        //        //        nextVC.YourLabel.text = "Passed Text"
        //        //        nextVC.YourLabel.text = YourArray[indexPath.row]
        //
        //        // Push to next view
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
        cell.nameLabel.text = item.author
        cell.viewLabel.text = String(item.likes)
        cell.postImage.layer.cornerRadius = 8.0
        cell.postImage.clipsToBounds = true
        
        // Configure the cell...
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Table Selected Row \(indexPath.row)")
        let vc = storyboard?.instantiateViewController(withIdentifier: "ImageSelectedController") as! ImageSelectedController
        for index in indexPath.row...(items.count - 1) {
            vc.items.append(items[index])
        }
        var item = items[indexPath.row]
//        vc.imageName = UIImage.init(named: item.imageName)!
//        vc.nameLabel.text = item.author
//        vc.likesLabel.text = String(item.likes)
//
//        print(UIImage.init(named: items[indexPath.row].imageName)!)
//        //        vc.setupView(image: UIImage.init(named: items[indexPath.row].imageName)!)
//        self.present(vc, animated: true, completion: nil)
//        //        let vc = ImageSelectedController()
//        //        nextVC.YourLabel.text = "Passed Text"
//        //        nextVC.YourLabel.text = YourArray[indexPath.row]
//
//        // Push to next view
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
