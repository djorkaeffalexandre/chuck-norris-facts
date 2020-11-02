//
//  FactCategory.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/20/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation

struct FactCategory: Decodable {
    let text: String

    init(text: String) {
        self.text = text
    }

    init(from decoder: Decoder) throws {
        self.text = try decoder.singleValueContainer().decode(String.self)
    }
}

extension FactCategory: Equatable {
    static func == (lhs: FactCategory, rhs: FactCategory) -> Bool {
        lhs.text == rhs.text
    }
}
