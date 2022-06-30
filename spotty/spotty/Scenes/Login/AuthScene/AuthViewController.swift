//
//  AuthViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 9.06.22.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {
    
    @IBOutlet private weak var webView: WKWebView!
    private var viewModel: AuthViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = SpotifyAuthProvider.shared.signInURL else { return }
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
    }
    
    private func displayUnsuccessfullLoginAlert() {
        let alert = UIAlertController(
            title: "Error",
            message: "Unsuccessfull log in attempt.",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}

extension AuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        let component = URLComponents(string: url.absoluteString)
        guard let code = component?.queryItems?.first(where: {$0.name == "code"})?.value else { return }
        
        AuthManager.shared.exchangeCodeForAccessToken(code: code) { [weak self] exchangeSucceeded in
            if exchangeSucceeded {
                DispatchQueue.main.async { self?.viewModel.handleSuccessfullLogin() }
            } else {
                DispatchQueue.main.async { self?.displayUnsuccessfullLoginAlert() }
            }
        }
    }
}

extension AuthViewController {
    
    static func create(viewModel: AuthViewModelProtocol) -> UIViewController {
        let viewController = AuthViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
