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
    private var descriptionLabel: UILabel!
    private var dismissButton: UIButton!
    
    private var viewModel: DetailItemViewModelProtocol! = EpisodeDetailViewModel() // TODO: Create func
    
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
        button.tintColor = .init(white: 1, alpha: 0.7)
        button.setBackgroundImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        view.addSubview(button, anchors: [.top(20), .trailing(-20), .height(35), .width(35)])
    }
    
    private func createText() {
        titleLabel = UILabel()
        titleLabel.setCustomStyle(.detailViewTitle)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 2
        
        descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .justified
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView, anchors: [.top(view.bounds.width + 10), .leading(20), .trailing(-20)])
    }
    
    private func bind() {
        viewModel.imageSource.bindAndFire { [weak self] image in
            if let image = image { self?.imageView.image = image }
        }
        viewModel.title.bindAndFire { [weak self] title in
            if let title = title { self?.titleLabel.text = title }
        }
        viewModel.description.bindAndFire { [weak self] description in
            if let description = description { self?.descriptionLabel.text = description }
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

