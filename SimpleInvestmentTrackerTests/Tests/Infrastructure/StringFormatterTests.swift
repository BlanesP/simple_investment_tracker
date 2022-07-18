//
//  StringFormatterTests.swift
//  SimpleInvestmentTrackerTests
//
//  Created by Pau Blanes on 14/7/22.
//

import XCTest
@testable import SimpleInvestmentTracker

class StringFormatterTests: XCTestCase {
    let locale = Locale.current

    func testCurrencyFormatted() {
        XCTAssertEqual("20.25".currencyFormatted(locale: locale), "$20.25")
    }

    func testCurrencyFormattedNoDecimal() {
        XCTAssertEqual("20".currencyFormatted(locale: locale), "$20.00")
        XCTAssertEqual("0".currencyFormatted(locale: locale), "$0.00")
    }

    func testCurrencyFormattedEmpty() {
        XCTAssertEqual("".currencyFormatted(locale: locale), "")
    }

    func testCurrencyFormattedWord() {
        XCTAssertEqual("Hello world".currencyFormatted(locale: locale), "Hello world")
    }

    func testCurrencyFormattedThreeDecimals() {
        XCTAssertEqual("20.236".currencyFormatted(locale: locale), "$20.24")
        XCTAssertEqual("20.235".currencyFormatted(locale: locale), "$20.24")
        XCTAssertEqual("20.234".currencyFormatted(locale: locale), "$20.23")
    }
}
