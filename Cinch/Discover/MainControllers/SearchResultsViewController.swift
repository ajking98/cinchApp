//
//  SearchResultsViewController.swift
/*
    The view presented after the user searches a term (collection view)
 */
//  Created by Alsahlani, Yassin K on 2/5/20

import UIKit

class SearchResultsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    //data
    var searchTerm = ""
    var width: CGFloat = 0
    var height: CGFloat = 0
    var identifier = "Cell"
    var content: Set = Set<String>()
    var indexesToPop:[IndexPath] = []
    
    //views
    var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    //view controllers
    var initialNavigationController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        width = view.frame.width
        height = view.frame.height
        view.backgroundColor = .white
        setupNavigationBar()
        setupCollectionView()
        
        //Adding swipe to go back functionality to entire screen
        let popGestureRecognizer = self.navigationController!.interactivePopGestureRecognizer!
               if let targets = popGestureRecognizer.value(forKey: "targets") as? NSMutableArray {
                 let gestureRecognizer = UIPanGestureRecognizer()
                 gestureRecognizer.setValue(targets, forKey: "targets")
                 self.view.addGestureRecognizer(gestureRecognizer)
               }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    func setup(term: String) {
        searchTerm = term
        title = term
        
        let tag = searchTerm.lowercased()
        fetchContent(tag: tag)
        fetchSynonyms(tag: tag)
        fetchOthers(tag: tag)
    }
    
    
    func setupNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.customRed]
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "backIcon-black"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        let leftNavItem = UIBarButtonItem(customView: backButton)
        navigationItem.setLeftBarButton(leftNavItem, animated: false)
        
//        navigationController?.tabBarController?.tabBar.isHidden = false
        
        //Enables swiping back
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    
    func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset.top = 24
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(GenericCell.self, forCellWithReuseIdentifier: identifier)
        view.addSubview(collectionView)
        
        //constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    
    //MARK: - Fetching
    
    func fetchContent(tag: String) {
        TagStruct().readAllElementLinks(tagLabel: tag) { (contentKeys) in
            self.content = Set(contentKeys)
            self.collectionView.performBatchUpdates({
                for index in 0 ..< self.content.count {
                    self.collectionView.insertItems(at: [IndexPath(item: index, section: 0)])
                }
            }) { (isComplete) in
                for indexPath in self.indexesToPop.reversed() {
                    let contentToDeleteKey = self.content[self.content.index(self.content.startIndex, offsetBy: indexPath.item)]
                    TagStruct().deleteElement(tagLabel: tag, contentKey:contentToDeleteKey)
                }
            }
        }
        
    }
    
    private func fetchSynonyms(tag: String) {
        Helpers.findSynonyms(word: tag) { (synonymSet) in
            for tempWord in synonymSet {
                TagStruct().readAllElementLinks(tagLabel: tempWord) { (contentKeys) in
                    
                    let start = self.content.count
                    self.content = self.content.union(contentKeys)
                    
                    self.collectionView.performBatchUpdates({
                        for index in start ..< self.content.count {
                            self.collectionView.insertItems(at: [IndexPath(item: index, section: 0)])
                        }
                    }) { (isComplete) in
                        for indexPath in self.indexesToPop.reversed() {
                            let contentToDeleteKey = self.content[self.content.index(self.content.startIndex, offsetBy: indexPath.item)]
                            TagStruct().deleteElement(tagLabel: tag, contentKey: contentToDeleteKey)
                        }
                    }
                }
            }
        }
    }
    
    private func fetchOthers(tag: String) {
        print("this is the tag term:", tag)
        Helpers.findOthers(word: tag) { (images) in
            print("here are the images:", images[0])
            self.content.insert(images[0])
            let index = self.content.count - 1
            
            DispatchQueue.main.async {
                print("this is the collectionview index", index)
                self.collectionView.insertItems(at: [IndexPath(item: index, section: 0)])
//                self.collectionView.reloadData()
//                self.collectionView.performBatchUpdates({
//                    let cell = GenericCell()
//                    cell.setup(contentKey: images[0])
//                    self.content.insert(images[0])
////                    self.collectionView.insertItems(at: [IndexPath(item: index, section: 0)])
//                }) { (isComplete) in
//                    print("completed")
//                }
            }
            
        }
    }
    
    
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! GenericCell

        let contentKey = self.content[self.content.index(self.content.startIndex, offsetBy: indexPath.item)]
        
        cell.setup(contentKey: contentKey) {
            self.indexesToPop.append(indexPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GenericCell
        let contentKey = self.content[self.content.index(self.content.startIndex, offsetBy: indexPath.item)]
        
        cell.setup(contentKey: contentKey)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width * 0.5) - 0.5, height: (height) * 0.4)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0) //.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

}


class SearchResultsCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
//    let picCollection: UIImageView = {
//        let image = UIImage(named: "example\(3)")
//        let imageView = UIImageView(image: image)
//        return imageView
//    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        backgroundColor = .lightGray
        
//        addSubview(picCollection)
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": picCollection]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": picCollection]))
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
