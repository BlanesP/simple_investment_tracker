//
//  UpdatePortfolioUseCase.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 12/7/22.
//

import Combine

protocol UpdatePortfolioUseCase {
    func execute(_ portfolio: Portfolio) -> AnyPublisher<Void, Error>
}

final class DefaultUpdatePortfolioUseCase {
    private let repository: PortfolioRepository

    init(repository: PortfolioRepository) {
        self.repository = repository
    }
}

extension DefaultUpdatePortfolioUseCase: UpdatePortfolioUseCase {
    func execute(_ portfolio: Portfolio) -> AnyPublisher<Void, Error> {
        repository.update(portfolio: portfolio)
    }
}
