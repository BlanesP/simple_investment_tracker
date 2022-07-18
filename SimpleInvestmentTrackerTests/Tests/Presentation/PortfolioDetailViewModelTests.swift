//
//  PortfolioDetailViewModelTests.swift
//  SimpleInvestmentTrackerTests
//
//  Created by Pau Blanes on 15/7/22.
//

import Combine
import XCTest
@testable import SimpleInvestmentTracker

class PortfolioDetailViewModelTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()
    private let portfolio = Portfolio.mock
    private let addContributionUseCaseMock = AddContributionUseCaseMock()
    private let updatePortfolioUseCaseMock = UpdatePortfolioUseCaseMock()
    private lazy var viewModel = PortfolioDetailViewModel(
        portfolio: portfolio,
        addContributionUseCase: addContributionUseCaseMock,
        updatePortfolioUseCase: updatePortfolioUseCaseMock
    )

    override func tearDown() {
        super.tearDown()
        cancellables.removeAll()
    }

    //MARK: - Add Contribution

    func testAddContributionSuccess() {
        //Given
        addContributionUseCaseMock.result = ()
        XCTAssertEqual(viewModel.portfolio.contributions.count, 1)

        //When
        viewModel.input(.addContribution(date: Date(), amount: "$100"))

        //Then
        XCTAssertEqual(viewModel.portfolio.contributions.count, 2)
        XCTAssertEqual(viewModel.portfolio.contributions[1].amount, 100)
    }

    func testAddContributionEmptyAmount() {
        //Given
        var result: PortfolioDetailViewModel.ViewOutput?
        let expectation = self.expectation(description: "failure")
        XCTAssertEqual(viewModel.portfolio.contributions.count, 1)

        //When
        viewModel
            .output
            .sink(receiveValue: {
                result = $0
                expectation.fulfill()
            })
            .store(in: &cancellables)

        viewModel.input(.addContribution(date: Date(), amount: ""))

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertEqual(result, .error)
        XCTAssertEqual(viewModel.portfolio.contributions.count, 1)
        XCTAssertFalse(addContributionUseCaseMock.executed)
    }

    func testAddContributionFailure() {
        //Given
        addContributionUseCaseMock.result = BasicError()
        var result: PortfolioDetailViewModel.ViewOutput?
        let expectation = self.expectation(description: "failure")
        XCTAssertEqual(viewModel.portfolio.contributions.count, 1)

        //When
        viewModel
            .output
            .sink(receiveValue: {
                result = $0
                expectation.fulfill()
            })
            .store(in: &cancellables)

        viewModel.input(.addContribution(date: Date(), amount: "$100"))

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertEqual(result, .error)
        XCTAssertEqual(viewModel.portfolio.contributions.count, 1)
        XCTAssertTrue(addContributionUseCaseMock.executed)
    }

    //MARK: - Update Value

    func testUpdateValueSuccess() {
        //Given
        updatePortfolioUseCaseMock.result = ()
        XCTAssertEqual(viewModel.portfolio.value, 100)

        //When
        viewModel.input(.valueChanged(to: "$200"))

        //Then
        XCTAssertEqual(viewModel.portfolio.value, 200)
    }

    func testUpdateValueEmpty() {
        //Given
        XCTAssertEqual(viewModel.portfolio.value, 100)
        var result: PortfolioDetailViewModel.ViewOutput?
        let expectation = self.expectation(description: "failure")

        //When
        viewModel
            .output
            .sink(receiveValue: {
                result = $0
                expectation.fulfill()
            })
            .store(in: &cancellables)

        viewModel.input(.valueChanged(to: ""))

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertEqual(viewModel.portfolio.value, 100)
        XCTAssertEqual(result, .error)
        XCTAssertFalse(updatePortfolioUseCaseMock.executed)
    }

    func testUpdateValueSame() {
        //Given
        XCTAssertEqual(viewModel.portfolio.value, 100)

        //When
        viewModel.input(.valueChanged(to: "$100"))

        //Then
        XCTAssertEqual(viewModel.portfolio.value, 100)
        XCTAssertFalse(updatePortfolioUseCaseMock.executed)
    }

    func testUpdateValueError() {
        //Given
        updatePortfolioUseCaseMock.error = BasicError()
        XCTAssertEqual(viewModel.portfolio.value, 100)
        var result: PortfolioDetailViewModel.ViewOutput?
        let expectation = self.expectation(description: "failure")

        //When
        viewModel
            .output
            .sink(receiveValue: {
                result = $0
                expectation.fulfill()
            })
            .store(in: &cancellables)

        viewModel.input(.valueChanged(to: "$200"))

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertEqual(viewModel.portfolio.value, 100)
        XCTAssertEqual(result, .error)
        XCTAssertTrue(updatePortfolioUseCaseMock.executed)
    }
}
