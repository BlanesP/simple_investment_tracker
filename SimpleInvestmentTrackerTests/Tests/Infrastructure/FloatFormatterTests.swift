//
//  FloatFormatterTests.swift
//  SimpleInvestmentTrackerTests
//
//  Created by Pau Blanes on 14/7/22.
//

import XCTest
@testable import SimpleInvestmentTracker

class FloatFormatterTests: XCTestCase {

    let locale = Locale(identifier: "en_US")

    //MARK: - Currency Formatted String

    func testCurrencyString() {
        //Given
        let value: Float = 15.25
        let expectedResult = "$15.25"

        //When
        let result = value.currencyFormatted(locale: locale)

        //Then
        XCTAssertEqual(result, expectedResult)
    }

    func testCurrencyStringOneDecimal() {
        //Given
        let value: Float = 15.2
        let expectedResult = "$15.20"

        //When
        let result = value.currencyFormatted(locale: locale)

        //Then
        XCTAssertEqual(result, expectedResult)
    }

    func testCurrencyStringNoDecimals() {
        //Given
        let value: Float = 2
        let expectedResult = "$2.00"

        //When
        let result = value.currencyFormatted(locale: locale)

        //Then
        XCTAssertEqual(result, expectedResult)
    }

    func testCurrencyStringAbsolute() {
        //Given
        let value: Float = -2
        let expectedResult = "$2.00"

        //When
        let result = value.currencyFormatted(locale: locale)

        //Then
        XCTAssertEqual(result, expectedResult)
    }

    func testCurrencyStringNegative() {
        //Given
        let value: Float = -2
        let expectedResult = "-$2.00"

        //When
        let result = value.currencyFormatted(absolute: false, locale: locale)

        //Then
        XCTAssertEqual(result, expectedResult)
    }

    //MARK: - Percentage Formatted String

    func testPercentageString() {
        //Given
        let value: Float = 0.1525
        let expectedResult = "15.25%"

        //When
        let result = value.percentageFormatted(locale: locale)

        //Then
        XCTAssertEqual(result, expectedResult)
    }

    func testPercentageStringOneDecimal() {
        //Given
        let value: Float = 0.152
        let expectedResult = "15.20%"

        //When
        let result = value.percentageFormatted(locale: locale)

        //Then
        XCTAssertEqual(result, expectedResult)
    }

    func testPercentageStringNoDecimals() {
        //Given
        let value: Float = 0.15
        let expectedResult = "15.00%"

        //When
        let result = value.percentageFormatted(locale: locale)

        //Then
        XCTAssertEqual(result, expectedResult)
    }

    func testPercentageStringNegative() {
        //Given
        let value: Float = -0.15
        let expectedResult = "-15.00%"

        //When
        let result = value.percentageFormatted(locale: locale)

        //Then
        XCTAssertEqual(result, expectedResult)
    }

    //MARK: - Init From Currency String

    func testFromCurrencyString() {
        //Given
        let value = "$15.25"
        let expectedResult: Float = 15.25

        //When
        let result = Float(currencyFormattedString: value, locale: locale)

        //Then
        XCTAssertEqual(result, expectedResult)
    }

    func testFromCurrencyStringWrongFormat() {
        //Given
        let value = "$15,25"
        let expectedResult: Float = 0

        //When
        let result = Float(currencyFormattedString: value, locale: locale)

        //Then
        XCTAssertEqual(result, expectedResult)
    }

    func testFromCurrencyStringEmpty() {
        //Given
        let value = ""
        let expectedResult: Float = 0

        //When
        let result = Float(currencyFormattedString: value, locale: locale)

        //Then
        XCTAssertEqual(result, expectedResult)
    }

    func testFromCurrencyStringNoDecimals() {
        //Given
        let value = "$15"
        let expectedResult: Float = 15

        //When
        let result = Float(currencyFormattedString: value, locale: locale)

        //Then
        XCTAssertEqual(result, expectedResult)
    }
}
