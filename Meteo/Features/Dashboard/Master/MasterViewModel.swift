//
//  MasterViewModel.swift
//  Meteo
//
//  Created by Frédéric Mallet on 28/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import Foundation

import Meteo_Core

enum MasterCell {
    case forecast(date: Date, temperature: Double)
}

final class MasterViewModel {
    
    enum Constant {
        static let hourMorning: Int = 5
        static let hourA: Int = 14
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
                    return .forecast(date: key, temperature: morning?.temperature ?? 0)
                }
        }
    }
    
    func getCell(at indexPath: IndexPath) -> MasterCell {
        return cells[indexPath.row]
    }
}
