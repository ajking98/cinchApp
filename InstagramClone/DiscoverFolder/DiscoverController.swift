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
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    var items : [Item] = [Item]()
    let buttonBar = UIView()
    var tapped = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printChecks()
        
        addSearchBar()
        setUpTableView()
        setUpCollectionView()
        setUpCollectionViewItemSizes()
        addContent()
        addGestures()
        addSegmentControlAttributes()
        addSelectBar(color: UIColor.lightGray)
        let tvc = DiscoverTableController()
        tvc.items = items
    }
    
    func addSearchBar() {
        let frame = collectionView.frame
        var searchBar = SearchBar(frame: CGRect(x: 0, y: 0, width: frame.width * 0.88, height: 33))
        searchBar.center = CGPoint(x: collectionView.center.x, y: 21)
        let tapped = UITapGestureRecognizer(target: searchBar, action: #selector(searchBar.revertToNormal))
        tapped.cancelsTouchesInView = false
        view.addGestureRecognizer(tapped)
        searchBar.backgroundColor = .white
        collectionView.addSubview(searchBar)
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
        buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 3).isActive = true
        buttonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
        buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
    }
    
    func addGestures() {
        let panCollectionViewGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanCollectionView))
        panCollectionViewGesture.delegate = self
        panCollectionViewGesture.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(panCollectionViewGesture)
        
        let panTableViewGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTableViewPan))
        panTableViewGesture.delegate = self
        tableView.addGestureRecognizer(panTableViewGesture)
    }
    
//    func setUserDefaults() {
//        let defaults = UserDefaults(suiteName: "group.InstagramClone.messages")
//        defaults?.set(objectImages, forKey: "testImages")
//    }
    
    func printChecks() {
//        print("Collection View \(self.collectionView.center.x)" )
//        print("Table View \(self.tableView.center.x)" )
    }
    
    func addSegmentControlAttributes() {
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 18),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 18),
            NSAttributedString.Key.foregroundColor: UIColor.gray
            ], for: .selected)
    }
    
    @IBAction func switchLayouts(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {
            self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex) + 20
            print(self.buttonBar.frame.origin.x)
        }
        switch sender.selectedSegmentIndex {
        case 0:
            UIView.animateKeyframes(withDuration: 0.15, delay: 0, options: [], animations: {
                self.collectionView.center = CGPoint(x: 207, y: self.collectionView.center.y)
                self.tableView.center = CGPoint(x: 621, y: self.tableView.center.y)
            }, completion: nil)
        case 1:
            UIView.animateKeyframes(withDuration: 0.15, delay: 0, options: [], animations: {
                self.collectionView.center = CGPoint(x: -207, y: self.collectionView.center.y)
                self.tableView.center = CGPoint(x: 207, y: self.tableView.center.y)
            }, completion: nil)
        default:
            break
        }
    }
    
    @objc func handlePanCollectionView(gesture: UIPanGestureRecognizer) {
        gesture.isEnabled = true
        if gesture.state == .began || gesture.state == .changed {
            let translation = gesture.translation(in: self.view)
            if(gesture.view!.center.x < 210) {
                self.collectionView.center = CGPoint(x: gesture.view!.center.x + translation.x,y: gesture.view!.center.y)
                self.tableView.center = CGPoint(x: self.tableView.center.x + translation.x,y: self.collectionView.center.y)
                gesture.view!.center = self.collectionView.center
            }else {
                UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
                    self.collectionView.center = CGPoint(x: 207, y: gesture.view!.center.y)
                    self.buttonBar.frame.origin.x = 20
                    gesture.isEnabled = false
                }, completion: nil)
            }
            
            gesture.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
        } else if gesture.state == .ended {
            if tableView.center.x < 400 {
                UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
                    self.collectionView.center = CGPoint(x: -207, y: gesture.view!.center.y)
                    self.tableView.center = CGPoint(x: 207, y: gesture.view!.center.y)
                    self.buttonBar.frame.origin.x = 207
                    self.segmentedControl.selectedSegmentIndex = 1
                }, completion: nil)
                
            } else {
                UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
                    self.collectionView.center = CGPoint(x: 207, y: gesture.view!.center.y)
                    self.tableView.center = CGPoint(x: 621, y: gesture.view!.center.y)
                    self.buttonBar.frame.origin.x = 20
                    self.segmentedControl.selectedSegmentIndex = 0
                }, completion: nil)
            }
        }
    }
    
    @objc func handleTableViewPan(gesture: UIPanGestureRecognizer) {
            gesture.isEnabled = true
            if gesture.state == .began || gesture.state == .changed {
                let translation = gesture.translation(in: self.view)
                if(gesture.view!.center.x > 190) {
                    self.collectionView.center = CGPoint(x: self.collectionView.center.x + translation.x,y: gesture.view!.center.y)
                    self.tableView.center = CGPoint(x: gesture.view!.center.x + translation.x,y: self.collectionView.center.y)
                    gesture.view!.center = self.tableView.center
                }else {
                    UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
                        self.tableView.center = CGPoint(x: 207, y: gesture.view!.center.y)
                        self.buttonBar.frame.origin.x = 207
                        gesture.isEnabled = false
                    }, completion: nil)
                }
                
                gesture.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
            } else if gesture.state == .ended {
                if collectionView.center.x < 0 {
                    UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
                        self.collectionView.center = CGPoint(x: -207, y: gesture.view!.center.y)
                        self.tableView.center = CGPoint(x: 207, y: gesture.view!.center.y)
                        self.buttonBar.frame.origin.x = 207
                        self.segmentedControl.selectedSegmentIndex = 1
                    }, completion: nil)
                    
                } else {
                    UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {
                        self.collectionView.center = CGPoint(x: 207, y: gesture.view!.center.y)
                        self.tableView.center = CGPoint(x: 621, y: gesture.view!.center.y)
                        self.buttonBar.frame.origin.x = 20
                        self.segmentedControl.selectedSegmentIndex = 0
                    }, completion: nil)
                }
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
//        var item = items[indexPath.row]
//        let vc = storyboard?.instantiateViewController(withIdentifier: "A")
//        self.navigationController?.pushViewController(vc!, animated: true)
//        vc.imageName = UIImage.init(named: item.imageName)!
//        vc.nameLabel.text = item.author
//        vc.likesLabel.text = String(item.likes)
        
//        print(UIImage.init(named: items[indexPath.row].imageName)!)
//        vc.setupView(image: UIImage.init(named: items[indexPath.row].imageName)!)
//        self.present(vc, animated: true, completion: nil)
//        let vc = ImageSelectedController()
//        nextVC.YourLabel.text = "Passed Text"
//        nextVC.YourLabel.text = YourArray[indexPath.row]

        // Push to next view
//        self.navigationController?.pushViewController(vc!, animated: true)
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
