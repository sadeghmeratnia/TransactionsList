//
//  IntExtensionTests.swift
//  TransactionsListTests
//
//  Created by Sadegh on 5/20/23.
//

@testable import TransactionsList
import XCTest

final class IntExtensionTests: XCTestCase {
    func testToString() throws {
        let intNumber = 123
        let expectedValue = "123"

        XCTAssertEqual(intNumber.toString, expectedValue)
    }

    func testToStringOptionalMode() throws {
        let optionalInt: Int? = 123
        let expectedValue = "123"

        XCTAssertEqual(optionalInt?.toString, expectedValue)
    }

    func testIn3DigitFormatForSmallNumbers() throws {
        let smallNumber = 123
        let expectedNumber = "123"

        XCTAssertEqual(smallNumber.in3digitFormat, expectedNumber)
    }

    func testIn3DigitFormatForMediumNumbers() throws {
        let smallNumber = 12345
        let expectedNumber = "12,345"

        XCTAssertEqual(smallNumber.in3digitFormat, expectedNumber)
    }

    func testIn3DigitFormatForLargeNumbers() throws {
        let smallNumber = 123456789
        let expectedNumber = "123,456,789"

        XCTAssertEqual(smallNumber.in3digitFormat, expectedNumber)
    }

    func testIn3DigitFormatForOptionalNumbers() throws {
        let smallNumber: Int? = 123456789
        let expectedNumber = "123,456,789"

        XCTAssertEqual(smallNumber?.in3digitFormat, expectedNumber)
    }
}
