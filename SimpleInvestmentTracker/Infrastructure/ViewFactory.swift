//
//  ViewFactory.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 7/4/22.
//

import SwiftUI

struct ViewFactory {
    
    static var homeView: some View {
        HomeView(
            viewModel: HomeViewModel(
                getPortfolioListUseCase: DomainFactory.getPortfolioListUseCase,
                deletePortfolioUseCase: DomainFactory.deletePortfolioUseCase
            )
        )
    }

    static var addPortfolioView: some View {
        AddPortfolioView(
            viewModel: AddPortfolioViewModel(
                addPortfolioUseCase: DomainFactory.addPortfolioUseCase
            )
        )
    }
}

// MARK: - Domain

private extension ViewFactory {
    struct DomainFactory {

        //MARK: Repositories
        private static var portfolioRepository: PortfolioRepository {
            DefaultPortfolioRepository(
                coreDataSource: DefaultCoreDataSource()
            )
        }

        //MARK: UseCases
        static var getPortfolioListUseCase: GetPortfolioListUseCase {
            DefaultGetPortfolioListUseCase(repository: portfolioRepository)
        }

        static var addPortfolioUseCase: AddPortfolioUseCase {
            DefaultAddPortfolioUseCase(repository: portfolioRepository)
        }

        static var deletePortfolioUseCase: DeletePortfolioUseCase {
            DefaultDeletePortfolioUseCase(repository: portfolioRepository)
        }
    }

}
