//
//  FactViewModel.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/10/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation
import RxDataSources

final class FactViewModel {
    let fact: Fact

    let text: String
    let category: String
    var url: URL?

    init(fact: Fact) {
        self.fact = fact
        self.text = fact.value
        self.category = fact.categories.first?.text.uppercased() ?? L10n.FactCategory.uncategorized

        if let url = fact.url {
            self.url = URL(string: url)
        }
    }
}

extension FactViewModel: IdentifiableType {
    var identity: String {
        fact.id
    }
}

extension FactViewModel: Equatable {
    static func == (lhs: FactViewModel, rhs: FactViewModel) -> Bool {
        return lhs.fact == rhs.fact
    }
}
