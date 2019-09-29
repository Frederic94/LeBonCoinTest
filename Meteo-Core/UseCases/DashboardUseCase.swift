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
                        completion: @escaping ([Forecast]?) -> Void)
}

public final class GetDashboardUseCase: DashboardUseCase {
    
    private let remoteService: RemoteDashboardService
    
    public init(remoteService: RemoteDashboardService) {
        self.remoteService = remoteService
    }
    
    
    public func fetchForecasts(latitude: Double, longitude: Double,
                               completion: @escaping ([Forecast]?) -> Void) {
        remoteService.fetchForecasts(latitude: latitude, longitude: longitude) { values in
            guard let dict = values else {
                completion(nil)
                return
            }
            
            let forecast = dict.map { Forecast(date: $0.key,
                                               temperature: $0.value.temperature.value,
                                               pression: $0.value.pression.niveau_de_la_mer,
                                               pluie: $0.value.pluie) }
            completion(forecast)
        }
    }
    
}
