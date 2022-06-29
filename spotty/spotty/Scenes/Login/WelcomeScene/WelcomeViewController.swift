//
//  WelcomeViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 9.06.22.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private var viewModel: WelcomeViewModelProtocol!
    
    @IBOutlet weak private var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        logInButton.setCustomStyle(.logIn)
    }
    
    @IBAction private func didTapLogInButton() {
        viewModel.didTapButton()
    }
}

extension WelcomeViewController {
    
    static func create(viewModel: WelcomeViewModelProtocol) -> UIViewController {
        let viewController = WelcomeViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
