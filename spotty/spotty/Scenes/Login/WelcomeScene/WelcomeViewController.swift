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
        authVC.completeCodeForTokenExchange = { [weak self] exchangeSucceeded in
            DispatchQueue.main.async { self?.handleLogIn(exchangeSucceeded) }
        }
        navigationController?.pushViewController(authVC, animated: true)
    }
    
    /// Handles the Login attmept result.
    /// - Parameter logInSuccess: Indication whether the Login attempt was successfull.
    ///
    /// This method updates the UI and should only ever be called from the Main Thread.
    private func handleLogIn(_ logInSuccess: Bool) {
        guard logInSuccess else {
            displayUnsuccessfullLoginAlert()
            return
        }
        
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }
    
    /// Displayes an Alert indicating that the Login attempt was not successfull.
    ///
    /// This method updates the UI and should only ever be called from the Main Thread.
    private func displayUnsuccessfullLoginAlert() {
        let alert = UIAlertController(title: "Error",
                                      message: "Unsuccessfull log in attempt.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}
