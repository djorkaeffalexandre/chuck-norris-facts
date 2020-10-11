//
//  FactViewModel.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/10/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation

enum TextSize: Int {
    case small = 16
    case large = 24
}

final class FactViewModel {
    let text: String
    var url: URL?
    let textSize: TextSize

    init(fact: Fact) {
        self.text = fact.value
        if let factUrl = fact.url {
            self.url = URL(string: factUrl)
        }
        self.textSize = fact.value.count > 80 ? .small : .large
    }
}
