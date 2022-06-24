//
//  UITableView+configured.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 27.06.22.
//

import UIKit

extension UITableView {
    
    func configuredReuseableCell(_ reuseIdentifier: String,
                                 item: AnyHashable,
                                 indexPath: IndexPath) -> ReuseableCell {
        guard let cell = self.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath) as? ReuseableCell,
              let model = item as? BusinessModel
        else { fatalError() }
        
        cell.configure(with: model)
        return cell
    }
}
