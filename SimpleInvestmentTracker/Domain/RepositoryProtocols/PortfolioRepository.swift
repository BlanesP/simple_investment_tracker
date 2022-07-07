//
//  PortfolioRepository.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 21/6/22.
//

import Combine
import Foundation

protocol PortfolioRepository {
    func fetchPortfolios() -> AnyPublisher<[Portfolio], Error>
    func addPortfolio(_ portfolio: Portfolio) -> AnyPublisher<Void, Error>
    func deletePortfolio(ids: [UUID]) -> AnyPublisher<Void, Error>
}
