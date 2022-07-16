//
//  Date+Formatting.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 10/7/22.
//

import Foundation

enum DateFormat: String {
    case ddMMyyyy = "dd/MM/yyyy"
}

extension Date {
    func toString(format: DateFormat = .ddMMyyyy) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
}
