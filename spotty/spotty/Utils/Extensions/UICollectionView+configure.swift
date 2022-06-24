//
//  UICollectionView+configure.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 20.06.22.
//

import UIKit

extension UICollectionView {
    
    func configureReuseableCell<T: ReuseableCell>(_ cellType: T.Type,
                                                  item: AnyHashable,
                                                  indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(
            withReuseIdentifier: cellType.reuseIdentifier,
            for: indexPath) as? T,
              let model = item as? BusinessModel
        else { fatalError() }
        
        cell.configure(with: model)
        return cell
    }
    
    func configureSupplimentaryView<T: ReuseableHeader>(_ headerType: T.Type,
                                                        kind: String,
                                                        indexPath: IndexPath) -> T {
        guard let sectionHeader = self.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: headerType.reuseIdentifier,
            for: indexPath) as? T
        else { fatalError() }
        
        return sectionHeader
    }
}
