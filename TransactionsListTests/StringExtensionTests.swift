//
//  StringExtensionTests.swift
//  TransactionsListTests
//
//  Created by Sadegh on 5/19/23.
//

@testable import TransactionsList
import XCTest

final class StringExtensionTests: XCTestCase {
    func testInCardNumberFormat() throws {
        let cardNumber = "1234567890123456"
        let expectedResult = "1234 5678 9012 3456"
        let formattedCardNumber = cardNumber.inCardNumberFormat

        XCTAssertEqual(
            formattedCardNumber,
            expectedResult,
            "Expected \(expectedResult) not \(formattedCardNumber)"
        )
    }

    func testLocalized() {
        let localizedString = "search.placeholder".localized
        let expectedString = "Search transactions by name..."

        XCTAssertEqual(
            localizedString,
            expectedString,
            "Expected \(expectedString) not \(localizedString)"
        )
    }
}
