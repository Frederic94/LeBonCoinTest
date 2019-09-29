//
//  MasterViewModel.swift
//  Meteo
//
//  Created by Frédéric Mallet on 28/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import Foundation

import Meteo_Core
import Meteo_Components

enum MasterCell {
    case forecast(model: ForecastModel)
}

final class MasterViewModel {
    
    enum Constant {
        static let hourMorning: Int = 5
        static let hourAfternoon: Int = 14
    }
    
    private let useCase: DashboardUseCase
    private var data: [ForecastByDay]  = [] {
        didSet {
            createCells()
        }
    }
    
    // MARK: Public
    var reloadTableViewClosure: (()->())?
    var cells: [MasterCell] = [] {
        didSet {
            reloadTableViewClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cells.count
    }
    
    init(useCase: DashboardUseCase) {
        self.useCase = useCase
    }
    
    func fetch() {
        useCase.fetchForecasts(latitude: 0, longitude: 0) { [weak self] values in
            guard let self = self,
                let forecasts = values else { return }
            self.data = forecasts
                .sorted(by: { $0.date < $1.date })
        }
    }
    
    func getCell(at indexPath: IndexPath) -> MasterCell {
        return cells[indexPath.row]
    }
    
    func getForecast(at indexPath: IndexPath) -> ForecastByDay {
        return data[indexPath.row]
    }
}

private extension MasterViewModel {
    func createCells() {
        cells = data.map { value -> MasterCell in
            let morning = value.forecasts.first { value in
                let hour = Calendar.current.component(.hour, from: value.date)
                return hour == Constant.hourMorning
            }
            
            var morningTemp: String?
            if let morning = morning {
                morningTemp = morning.getTemperature()
            }
            
            let afternoon = value.forecasts.first { value in
                let hour = Calendar.current.component(.hour, from: value.date)
                return hour == Constant.hourAfternoon
            }
            
            var afternoonTemp: String?
            var iconName = ""
            if let afternoon = afternoon {
                afternoonTemp = afternoon.getTemperature()
                iconName = afternoon.getAnimationName()
            }
            
            
            let model = ForecastModel(dayName: value.date.dayName(),
                                      morningTemp: morningTemp, afternoonTemp: afternoonTemp,
                                      iconName: iconName)
            
            return .forecast(model: model)
        }
    }
}

extension Forecast {
    func getAnimationName() -> String {
        return self.rainLevel > 0 ? Asset.partlyshower.name : Asset.partlycloudy.name
    }
    
    func getTemperature() -> String {
        return String(format: "%.0f°", temperature - 273.15)
    }
}
