//
//  GetPortfolioUseCaseMock.swift
//  SimpleInvestmentTrackerTests
//
//  Created by Pau Blanes on 14/7/22.
//

import Combine
@testable import SimpleInvestmentTracker

final class GetPortfolioUseCaseMock: BaseMock {
    var result: Any?
    var error: BasicError?
}

extension GetPortfolioUseCaseMock: GetPortfolioListUseCase {
    func execute() -> AnyPublisher<[Portfolio], Error> {
        mockPublisherResult()
    }
}
