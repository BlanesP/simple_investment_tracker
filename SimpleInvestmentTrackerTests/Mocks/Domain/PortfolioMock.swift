//
//  PortfolioMock.swift
//  SimpleInvestmentTrackerTests
//
//  Created by Pau Blanes on 13/7/22.
//

import Foundation
@testable import SimpleInvestmentTracker

extension Portfolio {

    static var mock: Portfolio {
        .init(
            id: UUID(),
            name: "Name",
            value: 100,
            contributions: [mockContribution]
        )
    }

    static var mockContribution: Portfolio.Contribution {
        Portfolio.Contribution(date: Date(), amount: 50)
    }

    static var mockList: [Portfolio] {
        [mock]
    }
}
