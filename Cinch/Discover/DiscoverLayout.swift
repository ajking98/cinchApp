//
//  DiscoverLayout.swift
//  Cinch
//
//  Created by Ahmed Gedi on 7/5/19.
//  Copyright © 2019 Gedi, Ahmed M. All rights reserved.
//

import UIKit

protocol DiscoverLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize
}
class DiscoverLayout: UICollectionViewLayout {
    
    weak var delegate : DiscoverLayoutDelegate!
    
    var numberOfColumns = 2
    var cellPadding : CGFloat = 4
    
    var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentHeight: CGFloat = 0
    
    fileprivate var contentWidth : CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        return collectionView.bounds.width
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else {
            return
        }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        
        var xOffset = [CGFloat]()
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item : item, section: 0)
            
            let photoSize = delegate.collectionView(collectionView, sizeOfPhotoAtIndexPath: indexPath)
            
            let cellWidth = columnWidth
            var cellHeight = photoSize.height * cellWidth / photoSize.width
            
            cellHeight = cellPadding * 2 + cellHeight
            
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: cellWidth, height: cellHeight)
            
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + cellHeight
            
            if numberOfColumns > 1 {
                var isColumnChanged = false
                for index in (1..<numberOfColumns).reversed() {
                    if yOffset[index] >= yOffset[index - 1] {
                        column = index - 1
                        isColumnChanged = true
                    }
                    else {
                        break
                    }
                }
                
                if isColumnChanged {
                    continue
                }
            }
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    // TODO Consider deleting line below
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        return cache[indexPath.item]
//    }
}
