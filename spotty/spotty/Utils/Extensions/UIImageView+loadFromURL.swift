//
//  UIImageView+loadFromURL.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 16.06.22.
//

import UIKit

extension UIImageView {
    
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let imageData = try? Data(contentsOf: url),
                  let loadedImage = UIImage(data: imageData)
            else { return }
            
            self?.image = loadedImage
        }
    }
}
