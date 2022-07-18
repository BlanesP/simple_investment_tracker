//
//  AddPortfolioViewModelTests.swift
//  SimpleInvestmentTrackerTests
//
//  Created by Pau Blanes on 14/7/22.
//

import Combine
import XCTest
@testable import SimpleInvestmentTracker

class AddPortfolioViewModelTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()
    private let addPortfolioUseCaseMock = AddPortfolioUseCaseMock()
    private lazy var viewModel = AddPortfolioViewModel(addPortfolioUseCase: addPortfolioUseCaseMock)

    func testAddSucess() {
        //Given
        addPortfolioUseCaseMock.result = ()
        var result: AddPortfolioViewModel.ViewOutput?
        let expectation = self.expectation(description: "success")

        //When
        viewModel
            .output
            .sink(receiveValue: {
                result = $0
                expectation.fulfill()
            })
            .store(in: &cancellables)

        viewModel.input(.addPortfolio(name: "Name", value: "$100", contributed: "$50"))

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertEqual(result, .onAddSuccess)
    }

    func testAddFailure() {
        //Given
        addPortfolioUseCaseMock.error = BasicError()
        var result: AddPortfolioViewModel.ViewOutput?
        let expectation = self.expectation(description: "failure")

        //When
        viewModel
            .output
            .sink(receiveValue: {
                result = $0
                expectation.fulfill()
            })
            .store(in: &cancellables)

        viewModel.input(.addPortfolio(name: "Name", value: "$100", contributed: "$50"))

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertEqual(result, .error)
    }

    func testAddNoName() {
        //Given
        var result: AddPortfolioViewModel.ViewOutput?
        let expectation = self.expectation(description: "failure")

        //When
        viewModel
            .output
            .sink(receiveValue: {
                result = $0
                expectation.fulfill()
            })
            .store(in: &cancellables)

        viewModel.input(.addPortfolio(name: "", value: "$100", contributed: "$50"))

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertEqual(result, .error)
        XCTAssertFalse(addPortfolioUseCaseMock.executed)
    }

    func testAddNoValue() {
        //Given
        var result: AddPortfolioViewModel.ViewOutput?
        let expectation = self.expectation(description: "failure")

        //When
        viewModel
            .output
            .sink(receiveValue: {
                result = $0
                expectation.fulfill()
            })
            .store(in: &cancellables)

        viewModel.input(.addPortfolio(name: "Name", value: "", contributed: "$50"))

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertEqual(result, .error)
        XCTAssertFalse(addPortfolioUseCaseMock.executed)
    }

    func testAddNoContributed() {
        //Given
        var result: AddPortfolioViewModel.ViewOutput?
        let expectation = self.expectation(description: "failure")

        //When
        viewModel
            .output
            .sink(receiveValue: {
                result = $0
                expectation.fulfill()
            })
            .store(in: &cancellables)

        viewModel.input(.addPortfolio(name: "Name", value: "$100", contributed: ""))

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertEqual(result, .error)
        XCTAssertFalse(addPortfolioUseCaseMock.executed)
    }
}
