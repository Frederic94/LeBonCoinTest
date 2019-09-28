//
//  DashboardUseCase.swift
//  Meteo-Core
//
//  Created by Frédéric Mallet on 28/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import Foundation

protocol DashboardUseCase {
    func fetchForecasts(latitude: Double, longitude: Double,
                        completion: @escaping ([Date: Forecast]?) -> Void)
}

public final class GetDashboardUseCase: DashboardUseCase {
    
    private let remoteService: RemoteDashboardService
    
    public init(remoteService: RemoteDashboardService) {
        self.remoteService = remoteService
    }
    
    
    public func fetchForecasts(latitude: Double, longitude: Double,
                               completion: @escaping ([Date: Forecast]?) -> Void) {
        remoteService.fetchForecasts(latitude: latitude, longitude: longitude, completion: completion)
    }
    
}
