//
//  UICollectionView+register.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 20.06.22.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ type: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UICollectionReusableView>(_ type: T.Type) {
        register(T.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: T.identifier)
    }
    
    func configuredReuseableCell(_ reuseIdentifier: String,
                                 item: AnyHashable,
                                 indexPath: IndexPath) -> SelfConfiguringCell {
        guard let cell = self.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath) as? SelfConfiguringCell,
              let model = item as? BusinessModel
        else { fatalError() }
        
        cell.configure(with: model)
        return cell
    }
    
    func configuredSupplimentaryView(_ reuseIdentifier: String,
                                     title: String,
                                     kind: String,
                                     indexPath: IndexPath) -> SelfConfiguringHeader {
        guard let sectionHeader = self.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: reuseIdentifier,
            for: indexPath) as? SelfConfiguringHeader
        else { fatalError() }
        
        sectionHeader.configure(title: title)
        return sectionHeader
    }
}
