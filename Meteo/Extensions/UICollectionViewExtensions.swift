//
//  UICollectionViewExtensions.swift
//  Meteo
//
//  Created by Frédéric Mallet on 29/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import UIKit

extension UICollectionView {
    public func register<T: UICollectionViewCell>(nib: UINib?, forCellWithClass name: T.Type) {
        register(nib, forCellWithReuseIdentifier: String(describing: name))
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UICollectionViewCell for \(String(describing: name))")
        }
        return cell
    }

}
