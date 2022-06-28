//
//  SplashViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 28.06.22.
//

import SFBaseKit

class SplashViewController: BaseViewController {

    private var viewModel: SplashViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start()
    }
}

extension SplashViewController {
    
    static func create(viewModel: SplashViewModelProtocol) -> UIViewController {
        let viewController = SplashViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
