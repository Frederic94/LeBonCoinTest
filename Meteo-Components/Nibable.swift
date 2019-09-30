//
//  Nibable.swift
//  Meteo-Components
//
//  Created by Frédéric Mallet on 29/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import Foundation

public final class ComponentsBundle {
    public static let currentBundle: Bundle = Bundle(for: ComponentsBundle.self)
}

public protocol Nibable {
    static var nibName: String { get }
    static var nib: UINib { get }
    static var bundle: Bundle { get }
}

public extension Nibable {
    public static var nibName: String {
        return String(describing: self)
    }
    
    public static var nib: UINib {
        return UINib(nibName: nibName, bundle: bundle)
    }
    
    public static var bundle: Bundle {
        return ComponentsBundle.currentBundle
    }
}

public extension Nibable where Self: UIView {
    
    public static func viewFromNib() -> Self {
        guard let rootObject = nib.instantiate(withOwner: self, options: nil).first as? Self else {
            fatalError("The root object must be the \(String(describing: self)) class")
        }
        
        return rootObject
    }
}
