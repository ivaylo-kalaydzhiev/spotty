//
//  SplashViewModelCoordinatorDelegate.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 28.06.22.
//

import Foundation

protocol SplashViewModelCoordinatorDelegate: AnyObject {
    
    /// Navigate to ``WelcomeViewController`` or ``TabBarViewController`` .
    func didFinishSplashScene()
}
