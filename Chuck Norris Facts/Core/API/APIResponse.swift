//
//  APIResponse.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/30/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation

struct APIResponse {
    let statusCode: Int
    let data: Data?
}

extension APIResponse {
    func filter<R: RangeExpression>(statusCodes: R) throws -> APIResponse where R.Bound == Int {
        guard statusCodes.contains(statusCode) else {
            throw APIError.statusCode(statusCode)
        }
        return self
    }

    func filterSuccessfulStatusCodes() throws -> APIResponse {
        return try filter(statusCodes: 200...299)
    }
}
