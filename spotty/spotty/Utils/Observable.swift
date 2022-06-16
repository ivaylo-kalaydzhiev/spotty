//
//  Observable.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 16.06.22.
//

import Foundation

class Observable<T> {
    
    var value: T? {
        didSet {
            DispatchQueue.main.async { [weak self] in self?.listener?(self?.value) }
        }
    }
    
    private var listener: ((T?) -> Void)?

    init(_ value: T?) {
        self.value = value
    }
    
    func bind(_ listener: @escaping (T?) -> Void) {
        self.listener = listener
    }
}
