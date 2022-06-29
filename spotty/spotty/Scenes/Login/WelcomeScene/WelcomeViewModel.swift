//
//  WelcomeViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 28.06.22.
//

import SFBaseKit

protocol WelcomeViewModelProtocol: CoordinatableViewModel {
    
    func didTapButton()
}

class WelcomeViewModel: WelcomeViewModelProtocol {
    
    weak var delegate: WelcomeViewModelCoordinatorDelegate?
    
    func didTapButton() {
        delegate?.didFinishWelcomeScene()
    }
}
