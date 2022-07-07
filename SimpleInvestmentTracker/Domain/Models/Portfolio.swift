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
    let value: Float
    let contributed: Float
}
