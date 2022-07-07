//
//  String+Formatting.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 18/6/22.
//

import Foundation

extension String {

    var currencyFormatted: Self {
        guard let floatValue = Float(self) else { return self }
        return floatValue.currencyFormatted
    }
}
