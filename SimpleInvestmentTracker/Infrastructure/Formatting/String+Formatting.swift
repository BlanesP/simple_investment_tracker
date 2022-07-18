//
//  String+Formatting.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 18/6/22.
//

import Foundation

extension String {
    func currencyFormatted(absolute: Bool = true, locale: Locale = Locale.current) -> Self {
        guard let floatValue = Float(self) else { return self }
        return floatValue.currencyFormatted(absolute: absolute, locale: locale)
    }
}
