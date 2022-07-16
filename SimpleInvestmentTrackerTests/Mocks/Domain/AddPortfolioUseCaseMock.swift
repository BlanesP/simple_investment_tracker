//
//  AddPortfolioUseCaseMock.swift
//  SimpleInvestmentTrackerTests
//
//  Created by Pau Blanes on 14/7/22.
//

import Combine
import Foundation
@testable import SimpleInvestmentTracker

final class AddPortfolioUseCaseMock: BaseMock {
    var result: Any?
    var error: BasicError?

    var executed = false
}

extension AddPortfolioUseCaseMock: AddPortfolioUseCase {
    func execute(_ portfolio: Portfolio) -> AnyPublisher<Void, Error> {
        executed = true
        return mockPublisherResult()
    }
}
