//
//  RemoteDashboardService.swift
//  Meteo-Core
//
//  Created by Frédéric Mallet on 28/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import Foundation
import Alamofire

public final class RemoteDashboardService {
    
    enum Constants {
        static let baseUrl = "http://www.infoclimat.fr/public-api/gfs/json"
        static let token = "AxlWQVYoV3VVeFViUiQCK1kxVWANewEmVCgGZQ9qVShTOARlVjZRN1M9USwHKFVjUH1SMVphBTUGbVIqWigAYQNpVjpWPVcwVTpVMFJ9AilZd1U0DS0BJlQ2BmgPZ1UoUzIEZVYrUTJTPlE1BylVYFBrUjpaegUiBmRSMFoxAGoDZFY7VjBXM1U7VT5SfQIpWW9VYQ06AWpUPgYwD2ZVNVNhBGBWYVFiUzhRNQcpVWVQYVI6WmUFNQZjUjBaNQB8A39WS1ZGVyhVelV1UjcCcFl3VWANbAFt&_c=c1a6affaede3cb824b39e243306066f3"
    }
    
    public init() { }
    
    public func fetchForecasts(latitude: Double, longitude: Double, completion: @escaping ([Date: ForecastWS]?) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)?_ll=\(latitude),\(longitude)&_auth=\(Constants.token)") else {
            completion(nil)
            return
        }
        
        Alamofire.request(url,
                          method: .get)
            .validate()
            .response { response in
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(ForecastsResponseWS.self, from: data)
                    completion(response.forecasts)
                } catch let error {
                    print(error)
                    completion(nil)
                }
        }
    }
}
