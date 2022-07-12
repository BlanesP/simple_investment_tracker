//
//  DefaultPortfolioRepository.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 22/6/22.
//

import Combine
import CoreData

final class DefaultPortfolioRepository {

    private let coreDataSource: CoreDataSource

    init(coreDataSource: CoreDataSource) {
        self.coreDataSource = coreDataSource
    }
}

extension DefaultPortfolioRepository: PortfolioRepository {

    func addContribution(_ contribution: Portfolio.Contribution, toPortfolio portfolioId: UUID) -> AnyPublisher<Void, Error> {
        let request = PortfolioEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", portfolioId as NSUUID)

        return coreDataSource
            .fetch(request: request)
            .flatMap { results in
                return self.coreDataSource.save {
                    if let portfolioEntity = results.first {
                        let contributionEntity: ContributionEntity = self.coreDataSource.createEntity()
                        contributionEntity.amount = contribution.amount
                        contributionEntity.date = contribution.date
                        contributionEntity.portfolio = portfolioEntity
                    }
                }
            }
            .eraseToAnyPublisher()
    }

    func addPortfolio(_ portfolio: Portfolio) -> AnyPublisher<Void, Error> {
        coreDataSource
            .save { [weak self] in
                guard let coreDataSource = self?.coreDataSource else { return }

                let portfolioEntity: PortfolioEntity = coreDataSource.createEntity()
                portfolioEntity.id = portfolio.id
                portfolioEntity.name = portfolio.name
                portfolioEntity.value = portfolio.value
                portfolio.contributions.forEach {
                    let contribution: ContributionEntity = coreDataSource.createEntity()
                    contribution.amount = $0.amount
                    contribution.date = $0.date
                    contribution.portfolio = portfolioEntity
                }

            }
    }

    func deletePortfolio(ids: [UUID]) -> AnyPublisher<Void, Error> {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PortfolioEntity")
        request.predicate = NSPredicate(format: "%@ CONTAINS[cd] id", ids as [NSUUID])
        return coreDataSource
            .delete(request: request)
    }

    func fetchPortfolios() -> AnyPublisher<[Portfolio], Error> {
        coreDataSource
            .fetch(request: PortfolioEntity.fetchRequest())
            .tryMap { result in
                try result.map {
                    guard let id = $0.id,
                          let contributions = $0.contributions?.allObjects as? [ContributionEntity]
                    else {
                        throw CustomError.missingData
                    }

                    return Portfolio(
                        id: id,
                        name: $0.name ?? "",
                        value: $0.value,
                        contributions: contributions
                            .compactMap {
                                guard let date = $0.date else { return nil }
                                return Portfolio.Contribution(date: date, amount: $0.amount)
                            }
                    )
                }
            }
            .eraseToAnyPublisher()
    }

    func update(portfolio: Portfolio) -> AnyPublisher<Void, Error> {
        let request = PortfolioEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", portfolio.id as NSUUID)

        return coreDataSource
            .fetch(request: request)
            .flatMap { results in
                return self.coreDataSource.save {
                    if let portfolioEntity = results.first {
                        portfolioEntity.name = portfolio.name
                        portfolioEntity.value = portfolio.value
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
}
