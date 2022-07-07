//
//  AddPortfolioViewModel.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 21/6/22.
//

import Combine
import Foundation

final class AddPortfolioViewModel: ObservableObject {
    
    @Published var portfolioList = [Portfolio]()
    let viewState = PassthroughSubject<ViewState, Never>()

    private var cancellables = Set<AnyCancellable>()
    private let addPortfolioUseCase: AddPortfolioUseCase

    init(addPortfolioUseCase: AddPortfolioUseCase) {
        self.addPortfolioUseCase = addPortfolioUseCase
    }

    deinit {
        cancellables.removeAll()
    }
}

//MARK: - Trigger

extension AddPortfolioViewModel {

    func trigger(input: ViewInput) {
        switch input {
        case .addPortfolioPressed(let name, let value, let contributed):
            addPortfolioUseCase
                .execute(
                    Portfolio(
                        id: UUID(),
                        name: name,
                        value: Float(currencyFormattedString: value),
                        contributed: Float(currencyFormattedString: contributed)
                    )
                )
                .sink { [weak self] completion in
                    if case .failure(let error) = completion {
                        print(error) //TODO: Manage error
                    } else {
                        self?.viewState.send(.onAddSuccess)
                    }
                } receiveValue: { _ in }
                .store(in: &cancellables)
        }
    }
}

// MARK: - Components

extension AddPortfolioViewModel {

    enum ViewInput {
        case addPortfolioPressed(name: String, value: String, contributed: String)
    }

    enum ViewState {
        case onAddSuccess
    }
}
