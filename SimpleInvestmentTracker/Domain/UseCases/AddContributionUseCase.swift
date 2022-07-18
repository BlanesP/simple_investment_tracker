//
//  AddContributionUseCase.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 11/7/22.
//

import Combine
import Foundation

protocol AddContributionUseCase {
    func execute(_ contribution: Portfolio.Contribution, portfolioId: UUID) -> AnyPublisher<Void, Error>
}

final class DefaultAddContributionUseCase {
    private let repository: PortfolioRepository

    init(repository: PortfolioRepository) {
        self.repository = repository
    }
}

extension DefaultAddContributionUseCase: AddContributionUseCase {
    func execute(_ contribution: Portfolio.Contribution, portfolioId: UUID) -> AnyPublisher<Void, Error> {
        repository.addContribution(contribution, toPortfolio: portfolioId)
    }
}
