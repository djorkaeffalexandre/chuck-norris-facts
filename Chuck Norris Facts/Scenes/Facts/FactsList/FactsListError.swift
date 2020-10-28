//
//  FactsListError.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/28/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation

enum FactsListError: Error {

    case syncCategories(Error)
    case loadFacts(Error)

    var message: String {
        switch self {
        case .syncCategories: return "Error while trying to sync fact categories"
        case .loadFacts: return "Error while trying to load facts"
        }
    }

    var retry: Bool {
        switch self {
        case .syncCategories:
            return true
        default:
            return false
        }
    }
}
