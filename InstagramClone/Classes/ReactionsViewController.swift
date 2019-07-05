//
//  ReactionsViewController.swift
//  InstagramClone
//
//  Created by Ahmed Gedi on 6/23/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit
import CardParts
import RxSwift
import RxDataSources
import RxCocoa

struct MyStruct {
    var title: String
    var description: String
}

struct SectionOfCustomStruct {
    var header: String
    var items: [Item]
}

extension SectionOfCustomStruct: SectionModelType {

    typealias Item = MyStruct

    init(original: SectionOfCustomStruct, items: [Item]) {
        self = original
        self.items = items
    }
}

class ReactionsViewController: CardPartsViewController {

    let cardPartTextView = CardPartTextView(type: .normal)
    lazy var collectionViewCardPart = CardPartCollectionView(collectionViewLayout: self.collectionViewLayout)
    var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 170, height: 170)
        return layout
    }()
    let viewModel = CardPartCollectionViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewCardPart.collectionView.register(MyCustomCollectionViewCell.self, forCellWithReuseIdentifier: "MyCustomCollectionViewCell")
        collectionViewCardPart.collectionView.backgroundColor = .clear
        collectionViewCardPart.collectionView.showsHorizontalScrollIndicator = false

        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfCustomStruct>(configureCell: { (_, collectionView, indexPath, data) -> UICollectionViewCell in

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCustomCollectionViewCell", for: indexPath) as? MyCustomCollectionViewCell else { return UICollectionViewCell() }

            cell.setData(data)
            cell.isUserInteractionEnabled = true
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
            let flappy = UIImage(named: "flappy")
            cell.backgroundView = UIImageView.init(image: flappy)
            cell.layer.cornerRadius = 10
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.95, alpha: 1.0).cgColor
            cell.clipsToBounds = true
            return cell
        })

        viewModel.data.asObservable().bind(to: collectionViewCardPart.collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)

        collectionViewCardPart.collectionView.frame = CGRect(x: 0, y: 0, width: 200, height: 400)

        setupCardParts([cardPartTextView, collectionViewCardPart])
    }

    @objc func handleTap(tapGesture: UITapGestureRecognizer) {
        print("Tapped")
    }
}

class CardPartCollectionViewModel {

    typealias ReactiveSection = BehaviorRelay<[SectionOfCustomStruct]>
    var data = ReactiveSection(value: [])

    let emojis: [String] = ["😎", "🤪", "🤩", "👻", "🤟🏽", "💋", "💃🏽"]

    init() {

        var temp: [MyStruct] = []

        for i in 0...4 {

            temp.append(MyStruct(title: "Title #\(i)", description: "\(emojis[Int(arc4random_uniform(UInt32(emojis.count)))])"))
        }

        data.accept([SectionOfCustomStruct(header: "", items: temp)])
    }
}

class MyCustomCollectionViewCell: CardPartCollectionViewCardPartsCell {
    let bag = DisposeBag()

    let titleCP = CardPartTextView(type: .title)
    let descriptionCP = CardPartTextView(type: .normal)

    override init(frame: CGRect) {

        super.init(frame: frame)

        titleCP.margins = .init(top: 50, left: 20, bottom: 5, right: 30)
        descriptionCP.margins = .init(top: 15, left: 30, bottom: 0, right: 20)
        setupCardParts([titleCP, descriptionCP])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(_ data: MyStruct) {

        titleCP.text = data.title
        titleCP.textAlignment = .center
        titleCP.textColor = .white

        descriptionCP.text = data.description
        descriptionCP.textAlignment = .center
        descriptionCP.textColor = .white
    }
}

