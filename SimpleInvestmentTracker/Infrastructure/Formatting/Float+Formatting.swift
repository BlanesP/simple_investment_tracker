//
//  Float+Formatting.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 7/4/22.
//

import Foundation

extension Float {
    func currencyFormatted(absolute: Bool = true, locale: Locale = Locale.current) -> String {
        let formatter = NumberFormatter()

        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.locale = locale

        return formatter.string(
            from: NSNumber(value: absolute ? abs(self) : self)
        ) ?? "\(self)"
    }

    func percentageFormatted(locale: Locale = Locale.current) -> String {
        let formatter = NumberFormatter()

        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.locale = locale

        return formatter.string(from: NSNumber(value: self)) ?? "\(self)%"
    }
}

extension Float {
    init(currencyFormattedString: String, locale: Locale = Locale.current) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale

        guard let number = formatter.number(from: currencyFormattedString) else {
            self = 0
            return
        }
        self = number.floatValue
    }
}
