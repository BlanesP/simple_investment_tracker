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

    static func portfolioDetailView(for portfolio: Portfolio) -> some View {
        PortfolioDetailView(
            viewModel: PortfolioDetailViewModel(
                portfolio: portfolio,
                addContributionUseCase: DomainFactory.addContributionUseCase,
                updatePortfolioUseCase: DomainFactory.updatePortfolioUseCase
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

        static var addContributionUseCase: AddContributionUseCase {
            DefaultAddContributionUseCase(repository: portfolioRepository)
        }

        static var updatePortfolioUseCase: UpdatePortfolioUseCase {
            DefaultUpdatePortfolioUseCase(repository: portfolioRepository)
        }
    }

}
