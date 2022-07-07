//
//  DeletePortfolioUseCase.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 6/7/22.
//

import Combine
import Foundation

protocol DeletePortfolioUseCase {
    func execute(_ ids: [UUID]) -> AnyPublisher<Void, Error>
}

final class DefaultDeletePortfolioUseCase {
    private let repository: PortfolioRepository

    init(repository: PortfolioRepository) {
        self.repository = repository
    }
}

extension DefaultDeletePortfolioUseCase: DeletePortfolioUseCase {
    func execute(_ ids: [UUID]) -> AnyPublisher<Void, Error> {
        repository.deletePortfolio(ids: ids)
    }
}
