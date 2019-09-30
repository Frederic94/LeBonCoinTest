//
//  DetailViewModel.swift
//  Meteo
//
//  Created by Frédéric Mallet on 28/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import Foundation

import Meteo_Core
import Meteo_Components

final class DetailViewModel {
    
    // MARK: Public
    var cells: [ForecastByHourModel] = []
    
    var forecastByDay: ForecastByDay? {
        didSet {
            createCells()
        }
    }
    
    var numberOfCells: Int {
        return cells.count
    }
}

private extension DetailViewModel {
    func createCells() {
        guard let forecastByDay = forecastByDay else { return }
        self.cells = forecastByDay.forecasts
            .sorted(by: { $0.date < $1.date })
            .map { forecast in
                return ForecastByHourModel(hour: forecast.getHour(),
                                           animationName: forecast.getAnimationName(),
                                           temp: forecast.getTemperature(),
                                           pressure: forecast.getPressure())
        }
    }
}

extension Forecast {
    func getHour() -> String {
        let formatter = DateFormatter.hour
        return "\(formatter.string(from: date))h"
    }
    
    func getPressure() -> String {
        return "Press.\n\(pressure)"
    }
}
