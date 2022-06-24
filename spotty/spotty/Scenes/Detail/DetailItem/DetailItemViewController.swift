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
        
        descriptionTextView = UITextView()
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionTextView])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView, anchors: [.top(view.bounds.width + 10), .leading(20), .trailing(-20), .bottom(0)])
    }
    
    private func bind() {
        viewModel.imageSource.bindAndFire { [weak self] image in
            if let image = image { self?.imageView.image = image }
        }
        viewModel.title.bindAndFire { [weak self] title in
            if let title = title { self?.titleLabel.text = title }
        }
        viewModel.description.bindAndFire { [weak self] description in
            if let description = description { self?.descriptionTextView.attributedText = description.htmlAttributedString() }
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

extension String {
    func htmlAttributedString() -> NSAttributedString? {
        let htmlTemplate = """
        <!doctype html>
        <html>
          <head>
            <style>
              body {
                font-family: -apple-system;
                font-size: 14px;
              }
            </style>
          </head>
          <body>
            \(self)
          </body>
        </html>
        """

        guard let data = htmlTemplate.data(using: .utf8) else {
            return nil
        }

        guard let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
            ) else {
            return nil
        }

        return attributedString
    }
}
