//
//  UpdatePortfolioUseCaseTests.swift
//  SimpleInvestmentTrackerTests
//
//  Created by Pau Blanes on 13/7/22.
//

import Combine
import XCTest
@testable import SimpleInvestmentTracker

class UpdatePortfolioUseCaseTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()
    private let repository = PortfolioRepositoryMock()
    private lazy var useCase = DefaultUpdatePortfolioUseCase(repository: repository)

    override func tearDown() {
        super.tearDown()
        cancellables.removeAll()
    }

    func testExecuteSuccess() {
        //Given
        repository.result = ()
        var result: Void?
        let expectation = self.expectation(description: "success")

        //When
        useCase
            .execute(Portfolio.mock)
            .sink(
                receiveCompletion: { _ in expectation.fulfill() },
                receiveValue: { result = $0 }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.1)

        //Then
        XCTAssertNotNil(result)

    }

    func testExecuteFailure() {
        //Given
        repository.error = BasicError()
        var result: Error?
        let expectation = self.expectation(description: "failure")

        //When
        useCase
            .execute(Portfolio.mock)
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

}
