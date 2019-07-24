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
let viewImageSegueIdentifier = "viewImageSegueIdentifier"

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
    // Test
    var objectImages = ["f1", "f2", "f3", "f4", "f5"]
    let buttonBar = UIView()
    var tapped = true
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(sender)
        print("Leaving")
        let post = sender as! PostCard
        
        if segue.identifier == viewImageSegueIdentifier {
            if let vc = segue.destination as? ImageSelectedController {
                vc.imageName = post.imageView.image
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchBar()
        // Test
        print("Collection View \(self.collectionView.center.x)" )
        print("Table View \(self.tableView.center.x)" )
        
        let defaults = UserDefaults(suiteName: "group.InstagramClone.messages")
        defaults?.set(objectImages, forKey: "testImages")
        
        setUpCollectionView()
        setUpCollectionViewItemSizes()
        addContent()
        
        let panCollectionViewGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanCollectionView))
        collectionView.addGestureRecognizer(panCollectionViewGesture)
        
        let panTableViewGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTableViewPan))
        tableView.addGestureRecognizer(panTableViewGesture)
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 18),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 18),
            NSAttributedString.Key.foregroundColor: UIColor.gray
            ], for: .selected)
        
        
        // This needs to be false since we are using auto layout constraints
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor.lightGray
        
        view.addSubview(buttonBar)
        
        buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 3).isActive = true
        // Constrain the button bar to the left side of the segmented control
        buttonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
        // Constrain the button bar to the width of the segmented control divided by the number of segments
        buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
        
    }
    
    func addSearchBar() {
        let frame = collectionView.frame
        var searchBar = SearchBar(frame: CGRect(x: 0, y: 0, width: frame.width * 0.88, height: 33))
        searchBar.center = CGPoint(x: collectionView.center.x, y: 21)
        view.addGestureRecognizer(UITapGestureRecognizer(target: searchBar, action: #selector(searchBar.revertToNormal)))
        searchBar.backgroundColor = .white
        collectionView.addSubview(searchBar)
    }
    
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "PostCard", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
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
        if gesture.state == .began || gesture.state == .changed {
            let translation = gesture.translation(in: self.view)
            if(gesture.view!.center.x < 600) {
                self.collectionView.center = CGPoint(x: gesture.view!.center.x + translation.x,y: gesture.view!.center.y)
                self.tableView.center = CGPoint(x: self.tableView.center.x + translation.x,y: self.collectionView.center.y)
                gesture.view!.center = self.collectionView.center
            }else {
                self.collectionView.center = CGPoint(x: 207, y: gesture.view!.center.y)
                self.buttonBar.frame.origin.x = 20
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
            if gesture.state == .began || gesture.state == .changed {
                let translation = gesture.translation(in: self.view)
                if(gesture.view!.center.x < 600) {
                    self.collectionView.center = CGPoint(x: self.collectionView.center.x + translation.x,y: gesture.view!.center.y)
                    self.tableView.center = CGPoint(x: gesture.view!.center.x + translation.x,y: self.collectionView.center.y)
                    gesture.view!.center = self.tableView.center
                }else {
                    self.tableView.center = CGPoint(x: 207, y: gesture.view!.center.y)
                    self.buttonBar.frame.origin.x = 207
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
        cell.createGestures(target: self, action: #selector(handlePressed))
        
        return cell
    }
    
}


extension DiscoverController : DiscoverLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        let cellSize = UIImage(named: items[indexPath.item].imageName)!.size
        return cellSize
    }
}
