//
//  ForecastWS.swift
//  Meteo-Core
//
//  Created by Frédéric Mallet on 28/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import Foundation

public struct ForecastsResponseWS: Decodable {
    let forecasts: [Date: ForecastWS]
    
    public init(from decoder: Decoder) throws {
        let formatter = DateFormatter.yearMonthDayWithHourSeparatedByDash
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
        var array = [Date: ForecastWS]()
        for key in container.allKeys {
            if let codingKey = CustomCodingKeys(stringValue: key.stringValue),
                let value = try? container.decode(ForecastWS.self, forKey: codingKey),
                let date = formatter.date(from: key.stringValue) {
                array[date] = value
            }
        }
        
        self.forecasts = array
    }
}

private struct CustomCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    var intValue: Int?
    init?(intValue: Int) {
        return nil
    }
}

public struct ForecastWS: Decodable {
    let temperature: TemperatureWS
    let nebulosite: NebulositeWS
    let pression: PressionWS
    let pluie: Double
}

public struct NebulositeWS: Decodable {
    let totale: Double
    let haute: Double
    let moyenne: Double
    let basse: Double
}

public struct PressionWS: Decodable {
    let niveau_de_la_mer: Double
}


public struct TemperatureWS: Decodable {
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case value = "sol"
    }
}
