//
//  FactsListErrorViewModel.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 11/2/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation

struct FactsListErrorViewModel {

    let error: APIError
    let title: String
    let message: String
    var shouldRetry: Bool = false

    init(factsListError: FactsListError) {
        self.error = factsListError.error

        self.title = factsListError.message
        self.message = error.message

        switch factsListError {
        case .syncCategories:
            self.shouldRetry = error.code != APIError.noConnection.code
        default:
            break
        }
    }
}
