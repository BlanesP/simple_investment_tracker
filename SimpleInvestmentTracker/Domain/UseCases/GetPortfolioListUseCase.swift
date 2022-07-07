//
//  GetPortfolioListUseCase.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 22/6/22.
//

import Combine

protocol GetPortfolioListUseCase {
    func execute() -> AnyPublisher<[Portfolio], Error>
}

final class DefaultGetPortfolioListUseCase {

    private let repository: PortfolioRepository

    init(repository: PortfolioRepository) {
        self.repository = repository
    }
}

extension DefaultGetPortfolioListUseCase: GetPortfolioListUseCase {
    func execute() -> AnyPublisher<[Portfolio], Error> {
        repository.fetchPortfolios()
    }
}
