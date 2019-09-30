//
//  DataFactory.swift
//  Meteo-Core
//
//  Created by Frédéric Mallet on 28/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import Foundation


public struct DataFactory {
    public static func provideDashboardUseCase() -> DashboardUseCase {
        let remoteService = RemoteDashboardService()
        let path = URL(fileURLWithPath: NSHomeDirectory())
        let disk = DiskStorage(path: path)
        let storage = CodableStorage(storage: disk)
        return GetDashboardUseCase(remoteService: remoteService,
                                   storage: storage)
    }
}
