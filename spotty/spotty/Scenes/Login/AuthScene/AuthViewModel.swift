//
//  AuthViewModel.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 28.06.22.
//

import SFBaseKit

protocol AuthViewModelProtocol: CoordinatableViewModel {
    
    func handleSuccessfullLogin()
}

class AuthViewModel: AuthViewModelProtocol {
    
    weak var delegate: AuthViewModelCoordinatorDelegate?
    
    func handleSuccessfullLogin() {
        delegate?.didFinishAuthScene()
    }
}
