//
//  MasterViewModel.swift
//  Meteo
//
//  Created by Frédéric Mallet on 28/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import Foundation
import CoreLocation
import Connectivity

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
    var reloadTableViewClosure: (() -> Void)?
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
    
    func fetch(location: CLLocation) {
        useCase.fetchForecasts(latitude: location.coordinate.latitude,
                               longitude: location.coordinate.longitude) { [weak self] values in
            guard let self = self,
                let forecasts = values else { return }
            self.data = forecasts
                .sorted(by: { $0.date < $1.date })
        }
    }
    
    func getCell(at indexPath: IndexPath) -> MasterCell {
        return cells[indexPath.row]
    }
    
    func getForecast(at index: Int) -> ForecastByDay {
        return data[index]
    }
    
    func fetchCityAndCountry(from location: CLLocation,
                             completion: @escaping (_ city: String?, _ error: Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       error)
        }
    }
}

private extension MasterViewModel {
    func createCells() {
        cells = data.map { value -> MasterCell in
            let morning = value.forecasts.first { value in
                let hour = Calendar.current.component(.hour, from: value.date)
                return hour == Constant.hourMorning
            }
            
            let afternoon = value.forecasts.first { value in
                let hour = Calendar.current.component(.hour, from: value.date)
                return hour == Constant.hourAfternoon
            }
            
            let model = ForecastModel(dayName: value.date.dayName(),
                                      morningTemp: morning?.getTemperature(),
                                      afternoonTemp: afternoon?.getTemperature(),
                                      iconName: afternoon?.getAnimationName() ?? "")
            
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
