//
//  APIError.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/30/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation

/// A type representing possible errors API can throw.
enum APIError: Swift.Error {

    // Indicates a response failed to map to a Decodable object.
    case objectMapping(Swift.Error, APIResponse)

    // Indicated data was not received.
    case dataMapping(Swift.Error?)

    // Indicates a response failed with an invalid HTTP status code.
    case statusCode(APIResponse)

    // Indicates a response failed due to an underlying `Error`.
    case underlying(Swift.Error, APIResponse?)

    // Indicates that an `Endpoint` failed to map to a `URLRequest`.
    case requestMapping(String)

    // Indicates that an `Endpoint` failed to encode the parameters for the `URLRequest`.
    case parameterEncoding(Swift.Error)

    // Indicates that an Unknown error happened
    case unknown(Error?)
}

extension APIError {

    // Code for each error type.
    var code: Int {
        switch self {
        case .objectMapping:
            return 1
        case .dataMapping:
            return 2
        case .statusCode:
            return 3
        case .underlying:
            return 4
        case .requestMapping:
            return 5
        case .parameterEncoding:
            return 6
        case .unknown:
            return 7
        }
    }

    // Depending on error type, returns a `Response` object.
    var response: APIResponse? {
        switch self {
        case .objectMapping: return nil
        case .requestMapping: return nil
        case .parameterEncoding: return nil
        case .statusCode: return nil
        case .underlying: return nil
        case .dataMapping: return nil
        case .unknown: return nil
        }
    }

    // Depending on error type, returns an underlying `Error`.
    var underlyingError: Swift.Error? {
        switch self {
        case .objectMapping(let error, _): return error
        case .statusCode: return nil
        case .underlying(let error, _): return error
        case .requestMapping: return nil
        case .parameterEncoding(let error): return error
        case .dataMapping: return nil
        case .unknown: return nil
        }
    }
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dataMapping:
            return "Failed to read data from request."
        case .objectMapping:
            return "Failed to map data to a Decodable object."
        case .statusCode:
            return "Status code didn't fall within the given range."
        case .underlying(let error, _):
            return error.localizedDescription
        case .requestMapping:
            return "Failed to map Endpoint to a URLRequest."
        case .parameterEncoding(let error):
            return "Failed to encode parameters for URLRequest. \(error.localizedDescription)"
        case .unknown:
            return "Something unexpected happened."
        }
    }
}

extension APIError: Equatable {
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        return lhs.code == rhs.code
    }
}
