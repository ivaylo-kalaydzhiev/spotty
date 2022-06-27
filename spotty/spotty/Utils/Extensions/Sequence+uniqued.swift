//
//  Sequence+uniqued.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 27.06.22.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
