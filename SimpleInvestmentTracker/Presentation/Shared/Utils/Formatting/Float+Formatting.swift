//
//  Float+Formatting.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 7/4/22.
//

import Foundation

extension Float {
    var currencyFormatted: String {
        let formatter = NumberFormatter()

        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.locale = Locale.current

        return formatter.string(from: NSNumber(value: abs(self))) ?? "\(self)"
    }

    var percentageFormatted: String {
        let formatter = NumberFormatter()

        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        return formatter.string(from: NSNumber(value: self)) ?? "\(self)%"
    }
}

extension Float {
    init(currencyFormattedString: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        guard let number = formatter.number(from: currencyFormattedString) else {
            self = 0
            return
        }
        self = number.floatValue
    }
}
