//
//  ForecastCell.swift
//  Meteo-Components
//
//  Created by Frédéric Mallet on 29/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import UIKit
import Lottie


public struct ForecastModel {
    let dayName: String
    let morningTemp: String?
    let afternoonTemp: String?
    let iconName: String
    
    public init(dayName: String, morningTemp: String?, afternoonTemp: String?, iconName: String) {
        self.dayName = dayName
        self.morningTemp = morningTemp
        self.afternoonTemp = afternoonTemp
        self.iconName = iconName
    }
}


public final class ForecastCell: UITableViewCell, Nibable {
    @IBOutlet private weak var dayNameLabel: UILabel!
    @IBOutlet private weak var lottieContainer: UIView!
    @IBOutlet private weak var morningTempLabel: UILabel!
    @IBOutlet private weak var afternoonTempLabel: UILabel!
    
    
    public func configure(model: ForecastModel) {
        dayNameLabel.text = model.dayName
        morningTempLabel.text = model.morningTemp
        morningTempLabel.isHidden = model.morningTemp == nil
        afternoonTempLabel.text = model.afternoonTemp
        afternoonTempLabel.isHidden = model.afternoonTemp == nil
        
        lottieContainer.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        
        
        let animation = LOTAnimationView(name: model.iconName, bundle: ComponentsBundle.currentBundle)
        animation.loopAnimation = true
        animation.translatesAutoresizingMaskIntoConstraints = false
        lottieContainer.addSubview(animation)
        animation.heightAnchor.constraint(equalTo: lottieContainer.heightAnchor).isActive = true
        animation.widthAnchor.constraint(equalTo: lottieContainer.widthAnchor).isActive = true
        animation.topAnchor.constraint(equalTo: lottieContainer.topAnchor).isActive = true
        animation.bottomAnchor.constraint(equalTo: lottieContainer.bottomAnchor).isActive = true
        animation.leadingAnchor.constraint(equalTo: lottieContainer.leadingAnchor).isActive = true
        animation.trailingAnchor.constraint(equalTo: lottieContainer.trailingAnchor).isActive = true
        animation.play()
    }
}

extension UITableViewCell {
    open override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
