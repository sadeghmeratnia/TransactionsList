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

        XCTAssertEqual(formattedCardNumber, expectedResult)
    }

    func testLocalized() {
        let localizedString = "search.placeholder".localized
        let expectedString = "Search transactions by name..."

        XCTAssertEqual(localizedString, expectedString)
    }

    func testInStandardDateFormat() throws {
        let stringDate = "2023-05-20T14:30:00+0000"
        let expectedDate = "May 20, 2023, 14:30"

        XCTAssertEqual(stringDate.toStandardDateFormat!, expectedDate)
    }
}
