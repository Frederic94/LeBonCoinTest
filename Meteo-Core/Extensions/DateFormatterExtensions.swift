//
//  DateFormatterExtensions.swift
//  Meteo-Core
//
//  Created by Frédéric Mallet on 28/09/2019.
//  Copyright © 2019 Frédéric Mallet. All rights reserved.
//

import Foundation

extension DateFormatter {
    public static var yearMonthDayWithHourSeparatedByDash: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }
    
    public static var hour: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter
    }
}
