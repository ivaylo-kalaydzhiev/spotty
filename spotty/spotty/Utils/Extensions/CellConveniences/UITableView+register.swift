//
//  UITableView+register.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 27.06.22.
//

import UIKit

extension UITableView {

    func register<T: UITableViewCell>(_ type: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func configuredReuseableCell(_ reuseIdentifier: String,
                                 item: AnyHashable,
                                 indexPath: IndexPath) -> SelfConfiguringCell {
        guard let cell = self.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath) as? SelfConfiguringCell,
              let model = item as? BusinessModel
        else { fatalError() }
        
        cell.configure(with: model)
        return cell
    }
}
