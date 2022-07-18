//
//  AddPortfolioUseCase.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 22/6/22.
//

import Combine

protocol AddPortfolioUseCase {
    func execute(_ portfolio: Portfolio) -> AnyPublisher<Void, Error>
}

final class DefaultAddPortfolioUseCase {
    private let repository: PortfolioRepository

    init(repository: PortfolioRepository) {
        self.repository = repository
    }
}

extension DefaultAddPortfolioUseCase: AddPortfolioUseCase {
    func execute(_ portfolio: Portfolio) -> AnyPublisher<Void, Error> {
        repository.addPortfolio(portfolio)
    }
}
