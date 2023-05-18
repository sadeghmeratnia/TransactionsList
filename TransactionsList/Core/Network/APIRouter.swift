//
//  APIRouter.swift
//  TransactionsList
//
//  Created by Sadegh on 5/18/23.
//

import Foundation

public protocol BasicType: Codable, Hashable, RawRepresentable, CustomStringConvertible, CustomDebugStringConvertible {}

public protocol APIRouter {
    static var method: HTTPMethod { get }
    static var path: String { get }
    static var requestType: RequestType { get }
    var requestBody: Encodable? { get }
    var queryParams: [String]? { get }

    associatedtype ResponseType: Codable
}

public extension APIRouter {
    static var method: HTTPMethod {
        return .post
    }

    static var requestType: RequestType {
        switch method {
        case .post:
            return .jsonBody
        case .get:
            return .urlQuery
        default:
            return .httpHeader
        }
    }

    var queryParams: [String]? {
        nil
    }

    var requestBody: Encodable? {
        nil
    }

    static var retriable: Bool {
        return true
    }
}

public struct HTTPMethod: BasicType {
    public let rawValue: String
    public var description: String { return self.rawValue }
    public var debugDescription: String {
        return "HTTP Method: \(self.rawValue)"
    }

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    init(_ description: String) {
        self.rawValue = description.uppercased()
    }

    public static let get = HTTPMethod(rawValue: "GET")
    public static let post = HTTPMethod(rawValue: "POST")
    public static let delete = HTTPMethod(rawValue: "DELETE")
    public static let head = HTTPMethod(rawValue: "HEAD")
    public static let patch = HTTPMethod(rawValue: "PATCH")
}

public enum RequestType {
    case httpHeader
    case jsonBody
    case multipartFromData
    case urlQuery
}
