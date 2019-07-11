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
    
    @IBOutlet weak var collectionView: UICollectionView!
    var items : [Item] = [Item]()
    
    
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
        setUpCollectionView()
        setUpCollectionViewItemSizes()
        addContent()
        
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
