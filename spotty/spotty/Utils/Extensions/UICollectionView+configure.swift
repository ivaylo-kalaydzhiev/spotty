//
//  UICollectionView+configure.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 20.06.22.
//

import UIKit

extension UICollectionView {
    
    func configuredReuseableCell(_ reuseIdentifier: String,
                                 item: AnyHashable,
                                 indexPath: IndexPath) -> ReuseableCell {
        guard let cell = self.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath) as? ReuseableCell,
              let model = item as? BusinessModel
        else { fatalError() }
        
        cell.configure(with: model)
        return cell
    }
    
    func configuredSupplimentaryView(_ reuseIdentifier: String,
                                     title: String,
                                     kind: String,
                                     indexPath: IndexPath) -> ReuseableHeader {
        guard let sectionHeader = self.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: reuseIdentifier,
            for: indexPath) as? ReuseableHeader
        else { fatalError() }
        sectionHeader.title.text = title
        
        return sectionHeader
    }
}
