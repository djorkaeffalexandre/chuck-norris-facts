//
//  APIError.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/30/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation

protocol APIErrorType: LocalizedError {
    var code: Int { get }
    var message: String { get }
}

// A type representing possible errors API can throw.
enum APIError: Swift.Error {

    // Indicates that an Unknown error happened.
    case unknown(Swift.Error?)

    // Indicates data was not received.
    case mapping(Swift.Error?)

    // Indicates that user doesn't have a network connection.
    case noConnection

    // Indicates a response failed with an invalid HTTP status code.
    case statusCode(Int)

    // Indicates that the network response was not convertible to HTTPURLResponse.
    case connectionError
}

extension APIError: APIErrorType {

    // Code for each error type.
    var code: Int {
        switch self {
        case .unknown:
            return 0
        case .mapping:
            return 1
        case .noConnection:
            return 2
        case .statusCode:
            return 3
        case .connectionError:
            return 4
        }
    }

    // A description about the error.
    var message: String {
        switch self {
        case .unknown(let error):
            return error?.localizedDescription ?? "Something unexpected happened."
        case .mapping(let error):
            return error?.localizedDescription ?? "Error while trying to map response."
        case .noConnection:
            return "Internet Connection appears to be offline."
        case .statusCode(let code):
            return "Chuck Norris API returned \(code) statusCode."
        case .connectionError:
            return "Something unexpected happened with your connection."
        }
    }
}

extension APIError: Equatable {
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        return lhs.code == rhs.code
    }
}
