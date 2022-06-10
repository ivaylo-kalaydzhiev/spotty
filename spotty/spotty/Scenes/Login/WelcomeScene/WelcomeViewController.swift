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
        authVC.completionHandler = { [weak self] logInSuccess in
            DispatchQueue.main.async {
                self?.handleLogIn(logInSuccess)
            }
        }
        authVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(authVC, animated: true)
    }
    
    private func handleLogIn(_ logInSuccess: Bool) {
        guard logInSuccess else {
            let alert = UIAlertController(title: "Error",
                                          message: "Unsuccessfull log in attempt.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }
}
