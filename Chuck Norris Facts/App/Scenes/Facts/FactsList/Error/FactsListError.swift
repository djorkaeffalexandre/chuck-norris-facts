//
//  FactsListError.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/28/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation

enum FactsListError {
    // Error related to syncCategories request
    case syncCategories(Error)
    // Error related to searchFacts request
    case searchFacts(Error)
}

extension FactsListError {

    // APIError related to the error.
    var error: APIError {
        switch self {
        case .syncCategories(let error):
            return (error as? APIError) ?? APIError.unknown(error)
        case .searchFacts(let error):
            return (error as? APIError) ?? APIError.unknown(error)
        }
    }

    // A code to check where the error come.
    var code: Int {
        switch self {
        case .syncCategories:
            return 0
        case .searchFacts:
            return 1
        }
    }
}

extension FactsListError: Equatable {
    static func == (lhs: FactsListError, rhs: FactsListError) -> Bool {
        lhs.code == rhs.code
    }
}
