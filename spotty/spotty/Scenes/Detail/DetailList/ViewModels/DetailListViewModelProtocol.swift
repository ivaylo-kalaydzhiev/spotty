//
//  DetailListViewModeProtocol.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 24.06.22.
//

import Foundation

protocol DetailListViewModelProtocol {
    
    var imageURL: Observable<String> { get }
    var title: Observable<String> { get }
    var items: Observable<[BusinessModel]> { get }
}
