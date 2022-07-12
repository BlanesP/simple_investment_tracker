//
//  AddPortfolioViewModel.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 21/6/22.
//

import Combine
import Foundation

final class AddPortfolioViewModel: BaseViewModel {
    
    @Published var portfolioList = [Portfolio]()
    let output = PassthroughSubject<ViewOutput, Never>()

    private var cancellables = Set<AnyCancellable>()
    private let addPortfolioUseCase: AddPortfolioUseCase

    init(addPortfolioUseCase: AddPortfolioUseCase) {
        self.addPortfolioUseCase = addPortfolioUseCase
    }

    deinit {
        print("AddPortfolioViewModel released")
        cancellables.removeAll()
    }
}

//MARK: - Trigger

extension AddPortfolioViewModel {

    func input(_ input: ViewInput) {
        switch input {
        case .addPortfolioPressed(let name, let value, let contributed):
            addPortfolio(
                Portfolio(
                    id: UUID(),
                    name: name,
                    value: Float(currencyFormattedString: value),
                    contributions: [
                        Portfolio.Contribution(
                            date: Date(),
                            amount: Float(currencyFormattedString: contributed)
                        )
                    ]
                )
            )
        }
    }

    enum ViewInput {
        case addPortfolioPressed(name: String, value: String, contributed: String)
    }

    enum ViewOutput {
        case onAddSuccess
        case error
    }
}

//MARK: - Private methods

private extension AddPortfolioViewModel {
    func addPortfolio(_ portfolio: Portfolio) {
        addPortfolioUseCase
            .execute(
                portfolio
            )
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.output.send(.error)
                } else {
                    self?.output.send(.onAddSuccess)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
