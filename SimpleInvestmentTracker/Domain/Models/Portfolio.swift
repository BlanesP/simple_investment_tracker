//
//  Portfolio.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 21/6/22.
//

import Foundation

struct Portfolio: Identifiable {
    let id: UUID
    let name: String
    var value: Float
    var contributions: [Contribution]
}

extension Portfolio {
    struct Contribution: Hashable {
        let date: Date
        let amount: Float
    }
}
