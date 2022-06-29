//
//  DetailItemViewController.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 24.06.22.
//

import UIKit

class DetailItemViewController: UIViewController {
    
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var descriptionTextView: UITextView!
    private var dismissButton: UIButton!
    
    private var viewModel: DetailItemViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        bind()
    }
    
    override var prefersStatusBarHidden: Bool { true }
    
    private func setupUI() {
        createImageView()
        createText()
    }
    
    private func createImageView() {
        imageView = UIImageView()
        view.addSubview(imageView, anchors: [.top(0), .leading(0), .trailing(0), .height(view.bounds.width)])
        createDismissButton()
    }
    
    private func createDismissButton() {
        let button = UIButton()
        button.setCustomStyle(.dismiss)
        view.addSubview(button, anchors: [.top(20), .trailing(-20), .height(35), .width(35)])
    }
    
    private func createText() {
        titleLabel = UILabel()
        titleLabel.setCustomStyle(.detailItemTitle)
        
        descriptionTextView = UITextView()
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionTextView])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView, anchors: [.top(view.bounds.width + 10), .leading(20), .trailing(-20), .bottom(0)])
    }
    
    private func bind() {
        viewModel.imageURL.bindAndFire { [weak self] imageURL in
            if let imageURL = imageURL { self?.imageView.loadFrom(URLAddress: imageURL) }
        }
        viewModel.title.bindAndFire { [weak self] title in
            if let title = title { self?.titleLabel.text = title }
        }
        viewModel.description.bindAndFire { [weak self] description in
            guard let description = description else { return }
            self?.descriptionTextView.attributedText = description.createHTMLAttributedString()
        }
    }
}

extension DetailItemViewController {
    
    static func create(viewModel: DetailItemViewModelProtocol) -> UIViewController {
        let viewController = DetailItemViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
