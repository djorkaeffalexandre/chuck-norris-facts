//
//  FactsListError.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/28/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation

enum FactsListError {

    case syncCategories(Error)
    case searchFacts(Error)

    var error: APIError {
        switch self {
        case .syncCategories(let error):
            return (error as? APIError) ?? APIError.unknown(error)
        case .searchFacts(let error):
            return (error as? APIError) ?? APIError.unknown(error)
        }
    }

    var code: Int {
        switch self {
        case .syncCategories:
            return -100
        case .searchFacts:
            return -101
        }
    }
}

extension FactsListError: Equatable {
    static func == (lhs: FactsListError, rhs: FactsListError) -> Bool {
        lhs.code == rhs.code
    }
}
