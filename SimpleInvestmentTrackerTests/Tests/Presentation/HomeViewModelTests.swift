//
//  HomeViewModelTests.swift
//  SimpleInvestmentTrackerTests
//
//  Created by Pau Blanes on 14/7/22.
//

import Combine
import XCTest
@testable import SimpleInvestmentTracker

class HomeViewModelTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()
    private let getPortfolioUseCaseMock = GetPortfolioUseCaseMock()
    private let deletePortfolioUseCaseMock = DeletePortfolioUseCaseMock()
    private lazy var viewModel = HomeViewModel(
        getPortfolioListUseCase: getPortfolioUseCaseMock,
        deletePortfolioUseCase: deletePortfolioUseCaseMock
    )

    override func tearDown() {
        super.tearDown()
        cancellables.removeAll()
    }

    func testLoadDataSuccess() {
        //Given
        let expectedResult = [Portfolio.mock]
        getPortfolioUseCaseMock.result = expectedResult

        //When
        viewModel.input(.loadData)

        //Then
        XCTAssertTrue(!viewModel.portfolioList.isEmpty)
        XCTAssertEqual(viewModel.portfolioList[0].id, expectedResult[0].id)
    }

    func testLoadDataFailure() {
        //Given
        getPortfolioUseCaseMock.error = BasicError()
        var result: HomeViewModel.ViewOutput?
        let expectation = self.expectation(description: "failure")

        //When
        viewModel
            .output
            .sink(
                receiveValue: {
                    result = $0
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)

        viewModel.input(.loadData)

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertEqual(result, .error)
        XCTAssertTrue(viewModel.portfolioList.isEmpty)
    }

    func testDeleteSuccess() {
        //Given
        viewModel.portfolioList = [Portfolio.mock]
        deletePortfolioUseCaseMock.result = ()
        let indices: IndexSet = [0]

        //When
        viewModel.input(.deletePortfolios(indices))

        //Then
        XCTAssertTrue(viewModel.portfolioList.isEmpty)
        XCTAssertTrue(deletePortfolioUseCaseMock.executed)
    }

    func testDeleteFailure() {
        //Given
        viewModel.portfolioList = [Portfolio.mock]
        deletePortfolioUseCaseMock.error = BasicError()
        let expectation = self.expectation(description: "failure")
        var result: HomeViewModel.ViewOutput?
        let indices: IndexSet = [0]

        //When
        viewModel
            .output
            .sink(receiveValue: {
                result = $0
                expectation.fulfill()
            })
            .store(in: &cancellables)

        viewModel.input(.deletePortfolios(indices))

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertFalse(viewModel.portfolioList.isEmpty)
        XCTAssertTrue(deletePortfolioUseCaseMock.executed)
        XCTAssertEqual(result, .error)
    }

    func testDeleteEmpty() {
        //Given
        viewModel.portfolioList = [Portfolio.mock]
        let indices: IndexSet = []

        //When
        viewModel.input(.deletePortfolios(indices))

        //Then
        XCTAssertFalse(viewModel.portfolioList.isEmpty)
        XCTAssertFalse(deletePortfolioUseCaseMock.executed)
    }
}
