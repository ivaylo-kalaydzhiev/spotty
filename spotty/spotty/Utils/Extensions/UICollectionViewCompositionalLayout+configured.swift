//
//  UICollectionViewCompositionalLayout+configured.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 24.06.22.
//

import UIKit

extension UICollectionViewCompositionalLayout {
    
    func configured() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        self.configuration = config
        return self
    }
}
