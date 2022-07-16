//
//  PortfolioRepositoryTests.swift
//  SimpleInvestmentTrackerTests
//
//  Created by Pau Blanes on 13/7/22.
//

import Combine
import CoreData
import XCTest
@testable import SimpleInvestmentTracker

class PortfolioRepositoryTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()
    private let context = NSManagedObjectContext.mock
    private lazy var dataSource = CoreDataSourceMock(context: context)
    private lazy var repository = DefaultPortfolioRepository(coreDataSource: dataSource)

    override func tearDown() {
        super.tearDown()
        cancellables.removeAll()
    }


    //MARK: - Add Contribution

    func testAddContributionSuccess() {
        //Given
        dataSource.result = ()
        dataSource.fetchBeforeSaveResults = [PortfolioEntity.mock(context: context)]
        var result: Void?
        let expectation = self.expectation(description: "success")

        //When
        repository
            .addContribution(Portfolio.mockContribution, toPortfolio: UUID())
            .sink(
                receiveCompletion: { _ in expectation.fulfill() },
                receiveValue: { result = $0 }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertNotNil(result)
    }

    func testAddContributionFetchFailure() {
        //Given
        dataSource.result = ()
        dataSource.fetchBeforeSaveResults = []
        var result: BasicError?
        let expectation = self.expectation(description: "failure")

        //When
        repository
            .addContribution(Portfolio.mockContribution, toPortfolio: UUID())
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        result = error as? BasicError
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.message, "Fetch failed")
    }

    func testAddContributionFailure() {
        //Given
        dataSource.error = BasicError()
        dataSource.fetchBeforeSaveResults = [PortfolioEntity.mock(context: context)]
        var result: BasicError?
        let expectation = self.expectation(description: "failure")

        //When
        repository
            .addContribution(Portfolio.mockContribution, toPortfolio: UUID())
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        result = error as? BasicError
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertNotNil(result)
        XCTAssertNil(result!.message)
    }

    //MARK: - Add Portfolio

    func testAddPortfolioSuccess() {
        //Given
        dataSource.result = ()
        var result: Void?
        let expectation = self.expectation(description: "success")

        //When
        repository
            .addPortfolio(Portfolio.mock)
            .sink(
                receiveCompletion: {_ in expectation.fulfill() },
                receiveValue: { result = $0 }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertNotNil(result)
    }

    func testAddPortfolioFailure() {
        //Given
        dataSource.error = BasicError()
        var result: Error?
        let expectation = self.expectation(description: "failure")

        //When
        repository
            .addPortfolio(Portfolio.mock)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        result = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertNotNil(result)
    }

    //MARK: - Delete Portfolio

    func testDeletePortfolioSuccess() {
        //Given
        dataSource.result = ()
        var result: Void?
        let expectation = self.expectation(description: "success")

        //Then
        repository
            .deletePortfolio(ids: [Portfolio.mock.id])
            .sink(
                receiveCompletion: {_ in expectation.fulfill() },
                receiveValue: { result = $0 }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertNotNil(result)

    }

    func testDeletePortfolioFailure() {
        //Given
        dataSource.error = BasicError()
        var result: Error?
        let expectation = self.expectation(description: "failure")

        //Then
        repository
            .deletePortfolio(ids: [])
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        result = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertNotNil(result)
    }

    //MARK: - Fetch Portfolios

    func testFetchPortfoliosSuccess() {
        //Given
        let dataSourceResult = [PortfolioEntity.mock(context: context)]
        dataSource.result = dataSourceResult

        var result: [Portfolio]?
        let expectation = self.expectation(description: "success")

        //When
        repository
            .fetchPortfolios()
            .sink(
                receiveCompletion: {_ in expectation.fulfill() },
                receiveValue: { result = $0 }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result![0].id, dataSourceResult[0].id)
        XCTAssertEqual(result![0].name, dataSourceResult[0].name)
        XCTAssertEqual(result![0].value, dataSourceResult[0].value)
        XCTAssertEqual(result![0].contributions.count, dataSourceResult[0].contributions!.count)
    }

    func testFetchPortfoliosEmpty() {
        //Given
        dataSource.result = []

        var result: [Portfolio]?
        let expectation = self.expectation(description: "empty")

        //When
        repository
            .fetchPortfolios()
            .sink(
                receiveCompletion: {_ in expectation.fulfill() },
                receiveValue: { result = $0 }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.isEmpty)
    }

    func testFetchPortfoliosBrokenResult() {
        //Given
        dataSource.result = [PortfolioEntity(context: context)] //broken entity, no id

        var result: [Portfolio]?
        var resultError: BasicError?
        let expectation = self.expectation(description: "failure")

        //When
        repository
            .fetchPortfolios()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        resultError = error as? BasicError
                    }
                    expectation.fulfill()
                },
                receiveValue: { result = $0 }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertNil(result)
        XCTAssertNotNil(resultError)
        XCTAssertEqual(resultError!.message, "Error decoding PortfolioEntity")
    }

    func testFetchPortfoliosFailure() {
        //Given
        dataSource.error = BasicError()

        var result: Error?
        let expectation = self.expectation(description: "failure")

        //When
        repository
            .fetchPortfolios()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        result = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertNotNil(result)
    }

    //MARK: - Update Portfolio

    func testUpdatePortfolioSuccess() {
        //Given
        dataSource.fetchBeforeSaveResults = [PortfolioEntity.mock(context: context)]
        dataSource.result = ()
        var result: Void?
        let expectation = self.expectation(description: "success")

        //When
        repository
            .update(portfolio: Portfolio.mock)
            .sink(
                receiveCompletion: { _ in expectation.fulfill() },
                receiveValue: { result = $0 }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertNotNil(result)
    }

    func testUpdatePortfolioFailure() {
        //Given
        dataSource.error = BasicError()
        var result: Error?
        let expectation = self.expectation(description: "failure")

        //Then
        repository
            .update(portfolio: Portfolio.mock)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        result = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertNotNil(result)
    }

    func testUpdatePortfolioFetchFailure() {
        //Given
        dataSource.result = ()
        dataSource.fetchBeforeSaveResults = []
        var result: BasicError?
        let expectation = self.expectation(description: "failure")

        //When
        repository
            .update(portfolio: Portfolio.mock)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        result = error as? BasicError
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.message, "Fetch failed")
    }
}
