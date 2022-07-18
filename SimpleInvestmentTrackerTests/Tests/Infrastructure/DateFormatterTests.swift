//
//  DateFormatterTests.swift
//  SimpleInvestmentTrackerTests
//
//  Created by Pau Blanes on 14/7/22.
//

import XCTest
@testable import SimpleInvestmentTracker

class DateFormatterTests: XCTestCase {

    func testddMMyyyy() throws {
        //Given
        let expectedResult = "21/05/1991"
        let date = try Date(day: 21, month: 5, year: 1991)

        //When
        let result = date.toString(format: .ddMMyyyy)

        //Then
        XCTAssertEqual(result, expectedResult)
    }
}

extension Date {
    init(day: Int, month: Int, year: Int) throws {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day

        let calendar = Calendar(identifier: .gregorian)
        if let date = calendar.date(from: dateComponents) {
            self = date
        } else {
            throw BasicError(message: "Could not create date")
        }
    }
}
