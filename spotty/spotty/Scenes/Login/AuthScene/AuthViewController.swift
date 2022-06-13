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
    
    /// Called right after the Auth Manager has attempted to exchange Code for an Access Token.
    ///
    /// This property must be set in order to complete Code for Access Token exchange successfully.
    var completeCodeForTokenExchange: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        guard let url = SpotifyAuthProvider.shared.signInURL else { return }
        webView.load(URLRequest(url: url))
    }
}

extension AuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        let component = URLComponents(string: url.absoluteString)
        guard let code = component?.queryItems?.first(where: {$0.name == "code"})?.value else { return }
        
        AuthManager.shared.exchangeCodeForAccessToken(code: code) { [weak self] exchangeSucceeded in
            self?.completeCodeForTokenExchange?(exchangeSucceeded)
        }
    }
}

// TODO: Scroll View
