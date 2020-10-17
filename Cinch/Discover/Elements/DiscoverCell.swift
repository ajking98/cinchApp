//
//  TableViewCell.swift
//  Created by Alsahlani, Yassin K on 1/26/20.

import UIKit


class DiscoverCell: UITableViewCell {
    
    /*
     Cell for tableView in DiscoverViewController
     */
    
    
    // MARK: Data
    
    private var cellHeight: CGFloat = 0
    private var cellWidth: CGFloat = 0
    private var identifier = "Cell"
    private var hashTagTerm = ""
    private var content:[String] = []
    private var indexesToPop: [Int] = []
    
    
    // MARK: Views
    
    let hashTagIcon = UIImageView(image: UIImage(named: "HashTag"))
    let upperText = UILabel(frame: CGRect.zero)
    var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    // MARK: Setup
    
    func setUp(hashTagTerm: String, cellSize: CGSize) {
        
        self.hashTagTerm = hashTagTerm.lowercased().capitalizeFirstLetter()
        self.selectionStyle = .none
        
        self.cellHeight = cellSize.height
        self.cellWidth = cellSize.width
        
        setupCollectionView()
        fetchContent()
        addHashTag()
        addTopText()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(GenericCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        //constraints
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.widthAnchor.constraint(equalToConstant: cellWidth),
            collectionView.heightAnchor.constraint(equalToConstant: 0.68 * cellHeight),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -0.07 * cellHeight)
        ])
        
        collectionView.contentInset.left = frame.width * 0.0387
    }
    
    //fetches the links for the term
    func fetchContent(){
        content = []
        
        TagStruct().readAllElements(tagLabel: hashTagTerm.lowercased()) { (tagElements) in
            for tagElement in tagElements {
                if tagElement.contentKey.count > 1 {
                    self.content.append(tagElement.contentKey)
                }
                else {
                    self.content.append(tagElement.link)
                }
            }
            self.collectionView.reloadData()
            
            self.collectionView.performBatchUpdates({
                self.popIndexes()
            }, completion: nil)
        }
    }
    
    
    func addHashTag() {
        addSubview(hashTagIcon)
        let leftMargin = frame.width * 0.0387
        
        //constraints
        hashTagIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hashTagIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: leftMargin),
            hashTagIcon.widthAnchor.constraint(equalToConstant: 0.147 * cellHeight),
            hashTagIcon.heightAnchor.constraint(equalToConstant: 0.147 * cellHeight),
            hashTagIcon.topAnchor.constraint(equalTo: topAnchor, constant: 0.09 * cellHeight),
        ])
    }
    
    func addTopText() {
        upperText.text = hashTagTerm
        upperText.textAlignment = .left
        
        addSubview(upperText)
        upperText.translatesAutoresizingMaskIntoConstraints = false
        
        //constraints
        NSLayoutConstraint.activate([
            upperText.leftAnchor.constraint(equalTo: hashTagIcon.rightAnchor, constant: 8),
            upperText.widthAnchor.constraint(equalToConstant: frame.width),
            upperText.bottomAnchor.constraint(equalTo: hashTagIcon.bottomAnchor),
            upperText.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    //TODO: Fix this so that it refreshes the cell when user goes back
    func refreshCell(indexPath: IndexPath) {
        ////        collectionView.reloadItems(at: [indexPath])
        //        let cell = collectionView.cellForItem(at: indexPath) as! GenericCell
        ////        cell.setup(contentKey: content[indexPath.item])
        //        cell.imageView.startAnimating()
    }
    
    
    func popIndexes() {
        self.indexesToPop.sort()
        for _ in self.indexesToPop {
            guard let item = self.indexesToPop.popLast() else { return }
            self.content.remove(at: item)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}


// MARK: Collectionview

extension DiscoverCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! GenericCell
        cell.setup(contentKey: content[indexPath.item]) {
            if !self.indexesToPop.contains(indexPath.item) {
                self.indexesToPop.append(indexPath.item)
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CellSelectedTable()
        vc.modalPresentationStyle = .fullScreen
        
        vc.setup(content: self.content, startingIndex: indexPath, refreshCell: refreshCell(indexPath:))
        parentViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GenericCell
        cell.setup(contentKey: content[indexPath.item])
    }
    
}


// MARK: - CollectionView Flow

extension UITableViewCell: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 0.27 * frame.width, height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.8
    }
}
