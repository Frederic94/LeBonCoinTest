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
            let dict = Dictionary(grouping: forecasts, by: { $0.date.beginning(of: .day) })
            self.cells = dict
                .compactMap { dict -> (key: Date, value: [Forecast])? in
                    guard let key = dict.key else { return nil }
                    return (key: key, value: dict.value)
                }
                .sorted(by: { $0.key < $1.key })
                .map { (key, values) -> MasterCell in
                    let morning = values.first { value in
                         let hour = Calendar.current.component(.hour, from: value.date)
                        return hour == Constant.hourMorning
                    }
                    
                    var morningTemp: String?
                    if let morning = morning {
                        morningTemp = "\(morning.temperatureCelsius)°"
                    }
                    
                    let afternoon = values.first { value in
                        let hour = Calendar.current.component(.hour, from: value.date)
                        return hour == Constant.hourAfternoon
                    }
                    
                    var afternoonTemp: String?
                    var iconName = ""
                    if let afternoon = afternoon {
                        afternoonTemp = "\(afternoon.temperatureCelsius)°"
                        iconName = afternoon.pluie > 0 ? Asset.partlyshower.name : Asset.partlycloudy.name
                    }
                    
                    
                    let model = ForecastModel(dayName: key.dayName(),
                                              morningTemp: morningTemp, afternoonTemp: afternoonTemp,
                                              iconName: iconName)
                    
                    return .forecast(model: model)
                }
        }
    }
    
    func getCell(at indexPath: IndexPath) -> MasterCell {
        return cells[indexPath.row]
    }
}
