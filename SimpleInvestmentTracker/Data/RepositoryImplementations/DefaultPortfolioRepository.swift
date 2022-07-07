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

    func fetchPortfolios() -> AnyPublisher<[Portfolio], Error> {
        coreDataSource
            .fetch(request: PortfolioEntity.fetchRequest())
            .tryMap { result in
                try result.map {
                    guard let id = $0.id else {
                        throw CustomError.missingData
                    }

                    return Portfolio(
                        id: id,
                        name: $0.name ?? "",
                        value: $0.value,
                        contributed: $0.contributed
                    )
                }
            }
            .eraseToAnyPublisher()
    }

    func addPortfolio(_ portfolio: Portfolio) -> AnyPublisher<Void, Error> {
        coreDataSource
            .save { [weak self] in
                guard let coreDataSource = self?.coreDataSource else { return }

                let entity: PortfolioEntity = coreDataSource.createEntity()
                entity.id = portfolio.id
                entity.name = portfolio.name
                entity.value = portfolio.value
                entity.contributed = portfolio.contributed
            }
    }

    func deletePortfolio(ids: [UUID]) -> AnyPublisher<Void, Error> {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PortfolioEntity")
        request.predicate = NSPredicate(format: "%@ CONTAINS[cd] id", ids as [NSUUID])
        return coreDataSource
            .delete(request: request)
    }
}
