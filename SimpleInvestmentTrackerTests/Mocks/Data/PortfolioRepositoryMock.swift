//
//  PortfolioRepositoryMock.swift
//  SimpleInvestmentTrackerTests
//
//  Created by Pau Blanes on 13/7/22.
//

import Combine
import Foundation
@testable import SimpleInvestmentTracker

final class PortfolioRepositoryMock: BaseMock {
    var result: Any?
    var error: BasicError?
}

extension PortfolioRepositoryMock: PortfolioRepository {
    func addContribution(_ contribution: Portfolio.Contribution, toPortfolio portfolioId: UUID) -> AnyPublisher<Void, Error> {
        mockPublisherResult()
    }

    func addPortfolio(_ portfolio: Portfolio) -> AnyPublisher<Void, Error> {
        mockPublisherResult()
    }

    func deletePortfolio(ids: [UUID]) -> AnyPublisher<Void, Error> {
        mockPublisherResult()
    }

    func fetchPortfolios() -> AnyPublisher<[Portfolio], Error> {
        mockPublisherResult()
    }

    func update(portfolio: Portfolio) -> AnyPublisher<Void, Error> {
        mockPublisherResult()
    }
}
