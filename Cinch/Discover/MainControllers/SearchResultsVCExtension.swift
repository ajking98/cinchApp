//
//  SearchResultsVCExtension.swift
/*
    This extension is not targeting iMessage
 */
//  Created by Alsahlani, Yassin K on 2/10/20
//

import Foundation
import UIKit


extension SearchResultsViewController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CellSelectedTable()
        vc.modalPresentationStyle = .fullScreen
        vc.content = Array(content)
        vc.startingIndex = indexPath
        navigationController?.pushViewController(vc, animated: true)
    }
}
