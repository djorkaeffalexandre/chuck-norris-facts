//
//  SearchFactsResponse.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/20/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation

struct SearchFactsResponse: Decodable {
    let total: Int
    let facts: [Fact]

    enum CodingKeys: String, CodingKey {
        case total
        case facts = "result"
    }
}
