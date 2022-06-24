//
//  DetailItemViewModelProtocol.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 24.06.22.
//

import UIKit

protocol DetailItemViewModelProtocol {
    
    var imageSource: Observable<UIImage> { get }
    var title: Observable<String> { get }
    var description: Observable<String> { get }
}
