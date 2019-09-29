//
//  DashboardUseCase.swift
//  Meteo-Core
//
//  Created by Frédéric Mallet on 28/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import Foundation

public protocol DashboardUseCase {
    func fetchForecasts(latitude: Double, longitude: Double,
                        completion: @escaping ([ForecastByDay]?) -> Void)
}

public final class GetDashboardUseCase: DashboardUseCase {
    
    private let remoteService: RemoteDashboardService
    
    public init(remoteService: RemoteDashboardService) {
        self.remoteService = remoteService
    }
    
    
    public func fetchForecasts(latitude: Double, longitude: Double,
                               completion: @escaping ([ForecastByDay]?) -> Void) {
        remoteService.fetchForecasts(latitude: latitude, longitude: longitude) { values in
            guard let dict = values else {
                completion(nil)
                return
            }
    
            let array = dict
                .map { Forecast(date: $0.key,
                                temperature: $0.value.temperature.value,
                                pressure: $0.value.pression.niveau_de_la_mer,
                                rainLevel: $0.value.pluie)
            }
            let grouping = Dictionary(grouping: array, by: { $0.date.beginning(of: .day) })
                .compactMap { dict -> ForecastByDay? in
                    guard let key = dict.key else { return nil }
                    return ForecastByDay(date: key, forecasts: dict.value)
            }
            
            completion(grouping)
        }
    }
    
}
