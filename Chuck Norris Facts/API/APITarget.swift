//
//  APITarget.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/30/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation

protocol APITarget {

    // The target's base `URL`.
    var baseURL: URL { get }

    // The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    // The HTTP method used in the request.
    var method: HTTPMethod { get }

    // The headers to be used in the request.
    var headers: [String: String]? { get }

    // Provides stub data for use in testing.
    var sampleData: Data? { get }

    // The type of HTTP task to be performed.
    var task: APITask { get }
}

extension APITarget {

    // Returns the `Endpoint` converted to a `URLRequest` if valid. Throws an error otherwise.
    func urlRequest() -> URLRequest {

        var url: URL
        let targetPath = self.path
        if targetPath.isEmpty {
            url = baseURL
        } else {
            url = baseURL.appendingPathComponent(targetPath)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        switch task {
        case .requestPlain:
            return request
        case .requestParameters(let parameters):
            return request.encoded(parameters: parameters)
        }
    }
}

extension APITarget {

    // Provides stub data for use in testing. Default is `Data()`.
    var sampleData: Data? { Data() }
}
