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
    let text: String
    var url: URL?

    init(fact: Fact) {
        self.text = fact.value
        if let factUrl = fact.url {
            self.url = URL(string: factUrl)
        }
    }
}

extension FactViewModel: IdentifiableType {
    var identity: String {
        text
    }
}

extension FactViewModel: Equatable { }
func == (lhs: FactViewModel, rhs: FactViewModel) -> Bool {
    return lhs.text == rhs.text
}
