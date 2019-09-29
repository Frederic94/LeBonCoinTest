//
//  ForecastByHourCell.swift
//  Meteo-Components
//
//  Created by Frédéric Mallet on 29/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import UIKit
import Lottie

public struct ForecastByHourModel {
    let hour: String
    let animationName: String
    let temp: String
    let pressure: String
    
    public init(hour: String, animationName: String, temp: String, pressure: String) {
        self.hour = hour
        self.animationName = animationName
        self.temp = temp
        self.pressure = pressure
    }
}

public final class ForecastByHourCell: UICollectionViewCell, Nibable {

    @IBOutlet private weak var hourLabel: UILabel!
    @IBOutlet private weak var lottieContainer: UIView!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel! {
        didSet {
            pressureLabel.numberOfLines = 0
        }
    }
    
    public func configure(model: ForecastByHourModel) {
        hourLabel.text = model.hour
        tempLabel.text = model.temp
        pressureLabel.text = ""//model.pressure
        
        let animation = LOTAnimationView(name: model.animationName, bundle: ComponentsBundle.currentBundle)
        animation.loopAnimation = true
        animation.translatesAutoresizingMaskIntoConstraints = false
        lottieContainer.addSubview(animation)
        animation.heightAnchor.constraint(equalToConstant: 50).isActive = true
        animation.widthAnchor.constraint(equalToConstant: 50).isActive = true
        animation.centerXAnchor.constraint(equalTo: lottieContainer.centerXAnchor).isActive = true
        animation.centerYAnchor.constraint(equalTo: lottieContainer.centerYAnchor).isActive = true
        animation.play()
    }
}
