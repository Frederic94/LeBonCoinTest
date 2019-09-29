//
//  UITableViewExtensions.swift
//  Meteo
//
//  Created by Frédéric Mallet on 29/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import UIKit

extension UITableView {
    
    public func register<T: UITableViewCell>(nib: UINib?, withCellClass name: T.Type) {
        register(nib, forCellReuseIdentifier: String(describing: name))
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UICollectionViewCell for \(String(describing: name))")
        }
        return cell
    }
}
