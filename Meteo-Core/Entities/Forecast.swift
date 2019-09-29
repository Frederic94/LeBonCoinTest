//
//  Forecast.swift
//  Meteo-Core
//
//  Created by Frédéric Mallet on 28/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import Foundation

public struct Forecast {
    public let date: Date
    public let temperature: Double
    //let nebulosite: NebulositeWS
    public let pression: Double
    public let pluie: Double
    
    public var temperatureCelsius: String {
         return String(format: "%.0f", temperature - 273.15)
    }
    
}
