//
//  DetailItemViewModelProtocol.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 24.06.22.
//

import Foundation

protocol DetailItemViewModelProtocol {
    
    var imageURL: Observable<String> { get }
    var title: Observable<String> { get }
    var description: Observable<String> { get }
    
    func dismissView()
}
