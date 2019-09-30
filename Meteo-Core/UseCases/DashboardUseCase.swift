//
//  DashboardUseCase.swift
//  Meteo-Core
//
//  Created by Frédéric Mallet on 28/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import Foundation
import Connectivity

public protocol DashboardUseCase {
    func fetchForecasts(latitude: Double, longitude: Double,
                        completion: @escaping ([ForecastByDay]?) -> Void)
}

public final class GetDashboardUseCase: DashboardUseCase {
    
    enum Constant {
        static let folderName = "forecasts"
    }
    
    private let remoteService: RemoteDashboardService
    private let storage: CodableStorage
    
    public init(remoteService: RemoteDashboardService, storage: CodableStorage) {
        self.remoteService = remoteService
        self.storage = storage
    }
    
    
    public func fetchForecasts(latitude: Double, longitude: Double,
                               completion: @escaping ([ForecastByDay]?) -> Void) {
        if Reachability.isConnectedToNetwork() {
           self.callWS(latitude: latitude, longitude: longitude, completion: completion)
        } else {
            do {
                let forecasts: [ForecastByDay] = try self.storage.fetch(for: Constant.folderName)
                completion(forecasts)
            } catch {
                completion(nil)
            }
        }
    }
}

private extension GetDashboardUseCase {
    func callWS(latitude: Double, longitude: Double,
                completion: @escaping ([ForecastByDay]?) -> Void) {
        remoteService.fetchForecasts(latitude: latitude, longitude: longitude) {  [storage] values in
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
            
            do {
                try storage.save(grouping, for: Constant.folderName)
            } catch {
                print("error save storage")
            }
            
            completion(grouping)
        }
    }
}
