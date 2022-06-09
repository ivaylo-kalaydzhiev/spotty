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
        
        // logInButton.setCustomStyle(.logInButton)
        logInButton.clipsToBounds = true
        logInButton.layer.cornerRadius = 10
    }
    
    @IBAction private func didTapLogInButton() {
        let authVC = AuthViewController()
        authVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(authVC, animated: true)
    }
}
