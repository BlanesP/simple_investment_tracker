//
//  UpdatePortfolioUseCaseMock.swift
//  SimpleInvestmentTrackerTests
//
//  Created by Pau Blanes on 15/7/22.
//

import Combine
import Foundation
@testable import SimpleInvestmentTracker

final class UpdatePortfolioUseCaseMock: BaseMock {
    var result: Any?
    var error: BasicError?

    var executed = false
}

extension UpdatePortfolioUseCaseMock: UpdatePortfolioUseCase {
    func execute(_ portfolio: Portfolio) -> AnyPublisher<Void, Error> {
        executed = true
        return mockPublisherResult()
    }
}
