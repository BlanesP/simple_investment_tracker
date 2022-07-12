//
//  HomeViewModel.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 7/4/22.
//

import Foundation
import Combine

final class HomeViewModel: BaseViewModel {

    @Published var portfolioList = [Portfolio]()
    let output = PassthroughSubject<ViewOutput, Never>()

    private var cancellables = Set<AnyCancellable>()
    private let getPortfolioListUseCase: GetPortfolioListUseCase
    private let deletePortfolioUseCase: DeletePortfolioUseCase

    init(getPortfolioListUseCase: GetPortfolioListUseCase, deletePortfolioUseCase: DeletePortfolioUseCase) {
        self.getPortfolioListUseCase = getPortfolioListUseCase
        self.deletePortfolioUseCase = deletePortfolioUseCase
    }

    deinit {
        print("HomeViewModel released")
        cancellables.removeAll()
    }
}

//MARK: - Trigger

extension HomeViewModel {
    
    func input(_ input: ViewInput) {
        switch input {
        case .loadData:
            fetchData()
        case .deletePortfolios(let indexSet):
            deletePortfolios(indexSet: indexSet)
        }
    }

    enum ViewInput {
        case loadData
        case deletePortfolios(IndexSet)
    }

    enum ViewOutput {
        case error
    }
}

//MARK: - Private methods

private extension HomeViewModel {

    private func fetchData() {
        getPortfolioListUseCase
            .execute()
            .sink { [weak self] completion in
                guard case .failure = completion else { return }
                self?.output.send(.error)
            } receiveValue: { [weak self] result in
                self?.portfolioList = result
            }
            .store(in: &cancellables)
    }

    private func deletePortfolios(indexSet: IndexSet) {
        deletePortfolioUseCase
            .execute(
                indexSet.map { portfolioList[$0].id }
            )
            .sink { [weak self] completion in
                guard case .failure = completion else { return }
                self?.output.send(.error)
            } receiveValue: { [weak self] result in
                self?.portfolioList.remove(atOffsets: indexSet)
            }
            .store(in: &cancellables)
    }
}

extension HomeViewModel {
    var totalValue: Float {
        portfolioList.map { $0.value }.reduce(0, +)
    }

    var totalContributed: Float {
        portfolioList.map {
            $0.contributions
                .map({ $0.amount })
                .reduce(0, +)
        }
        .reduce(0, +)
    }
}
