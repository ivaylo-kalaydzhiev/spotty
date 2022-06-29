//
//  SplashViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 28.06.22.
//

import SFBaseKit

protocol SplashViewModelProtocol: CoordinatableViewModel {}

class SplashViewModel: SplashViewModelProtocol {
    
    // MARK: - Properties
    weak var delegate: SplashViewModelCoordinatorDelegate?
    
    // MARK: - Public Functions
    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.delegate?.didFinishSplashScene()
        }
    }
}

