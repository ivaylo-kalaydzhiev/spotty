//
//  WelcomeViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 9.06.22.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak private var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInButton.setCustomStyle(.logIn)
    }
    
    @IBAction private func didTapLogInButton() {
        let authVC = AuthViewController()
        navigationController?.pushViewController(authVC, animated: true)
    }
}
