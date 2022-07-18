//
//  PortfolioDetailViewModel.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 7/7/22.
//

import Combine
import Foundation

final class PortfolioDetailViewModel: BaseViewModel {

    @Published var portfolio: Portfolio
    let output = PassthroughSubject<ViewOutput, Never>()

    private var cancellables = Set<AnyCancellable>()
    private let addContributionUseCase: AddContributionUseCase?
    private let updatePortfolioUseCase: UpdatePortfolioUseCase?

    init(portfolio: Portfolio,
         addContributionUseCase: AddContributionUseCase?,
         updatePortfolioUseCase: UpdatePortfolioUseCase?) {
        self.portfolio = portfolio
        self.addContributionUseCase = addContributionUseCase
        self.updatePortfolioUseCase = updatePortfolioUseCase
    }

    deinit {
        print("\(type(of: self)) released")
        cancellables.removeAll()
    }
}

//MARK: - Trigger

extension PortfolioDetailViewModel {

    func input(_ input: ViewInput) {
        switch input {
        case .addContribution(_, let amount) where amount.isEmpty:
            output.send(.error)

        case .addContribution(let date, let amount):
            addContribution(
                Portfolio.Contribution(date: date, amount: Float(currencyFormattedString: amount))
            )

        case .valueChanged(let newValue) where newValue.isEmpty:
            output.send(.error)

        case .valueChanged(let newValue) where Float(currencyFormattedString: newValue) != portfolio.value:
            updatePortfolio(
                Portfolio(
                    id: portfolio.id,
                    name: portfolio.name,
                    value: Float(currencyFormattedString: newValue),
                    contributions: portfolio.contributions
                )
            )

        default:
            break
        }
    }

    enum ViewInput {
        case addContribution(date: Date, amount: String)
        case valueChanged(to: String)
    }

    enum ViewOutput {
        case error
    }
}

//MARK: - Private methods

private extension PortfolioDetailViewModel {
    func addContribution(_ contribution: Portfolio.Contribution) {
        addContributionUseCase?
            .execute(
                contribution,
                portfolioId: portfolio.id
            )
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.output.send(.error)
                } else {
                    self?.portfolio.contributions.append(contribution)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }

    func updatePortfolio(_ newPortfolio: Portfolio) {
        updatePortfolioUseCase?
            .execute(newPortfolio)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.output.send(.error)
                } else {
                    self?.portfolio = newPortfolio
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}

//MARK: - Utils

extension PortfolioDetailViewModel {
    var sortedContributions: [Portfolio.Contribution] {
        portfolio.contributions.sorted { $0.date > $1.date }
    }

    var totalContributed: Float {
        portfolio.contributions
            .map { $0.amount }
            .reduce(0, +)
    }
}
