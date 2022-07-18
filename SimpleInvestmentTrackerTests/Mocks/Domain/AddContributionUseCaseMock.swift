//
//  AddContributionUseCaseMock.swift
//  SimpleInvestmentTrackerTests
//
//  Created by Pau Blanes on 15/7/22.
//

import Combine
import Foundation
@testable import SimpleInvestmentTracker

final class AddContributionUseCaseMock: BaseMock {
    var result: Any?
    var error: BasicError?

    var executed = false
}

extension AddContributionUseCaseMock: AddContributionUseCase {
    func execute(_ contribution: Portfolio.Contribution, portfolioId: UUID) -> AnyPublisher<Void, Error> {
        executed = true
        return mockPublisherResult()
    }
}
