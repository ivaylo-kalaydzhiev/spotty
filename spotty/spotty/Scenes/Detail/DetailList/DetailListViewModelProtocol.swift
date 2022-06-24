//
//  DetailListViewModeProtocol.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 24.06.22.
//

import UIKit

protocol DetailListViewModelProtocol {
    associatedtype ItemType: Hashable
    
    var imageSource: Observable<UIImage> { get }
    var title: Observable<String> { get }
    var items: Observable<[ItemType]> { get }
}
