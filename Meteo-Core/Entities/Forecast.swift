//
//  Forecast.swift
//  Meteo-Core
//
//  Created by Frédéric Mallet on 28/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import Foundation

public struct ForecastByDay: Codable {
    public let date: Date
    public let forecasts: [Forecast]
}

public struct Forecast: Codable {
    public let date: Date
    public let temperature: Double
    public let pressure: Double
    public let rainLevel: Double
}
