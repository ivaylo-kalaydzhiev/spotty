//
//  NSCollectionLayoutSection+customSections.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 20.06.22.
//

import UIKit

extension NSCollectionLayoutSection {
    
    static func createFeaturedSectionLayout() -> NSCollectionLayoutSection {
        // Size, Item, Group, Section
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: 5, bottom: .zero, trailing: 5)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93),
                                               heightDimension: .fractionalWidth(0.93))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [layoutItem])
        
        // Section
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        // Header
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem.createSectionHeaderLayout()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    static func createHorizontalGroupsOfThreeLayout() -> NSCollectionLayoutSection {
        // Size, Item, Group, Section
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(0.33))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: 5, bottom: .zero, trailing: 5)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93),
                                               heightDimension: .fractionalWidth(0.55))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [layoutItem])
        
        // Section
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        // Header
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem.createSectionHeaderLayout()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    static func createVerticalLayout() -> NSCollectionLayoutSection {
        // Size, Item, Group, Section
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(75))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: 20, bottom: .zero, trailing: 20)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(100))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [layoutItem])
        
        // Section
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        // Header
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem.createSectionHeaderLayout()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    static func createPlaylistLayout() -> NSCollectionLayoutSection {
        // Size, Item, Group, Section
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(100))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(100))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [layoutItem])
        
        // Section
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
}
