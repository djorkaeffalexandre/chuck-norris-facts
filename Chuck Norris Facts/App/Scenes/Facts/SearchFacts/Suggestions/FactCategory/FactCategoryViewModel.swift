//
//  FactCategoryViewModel.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/20/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation
import RxDataSources

class FactCategoryViewModel {
    let category: FactCategory
    let text: String

    init(category: FactCategory) {
        self.category = category
        self.text = category.text.uppercased()
    }
}

extension FactCategoryViewModel: IdentifiableType {
    var identity: String {
        category.text
    }
}

extension FactCategoryViewModel: Equatable {
    static func == (lhs: FactCategoryViewModel, rhs: FactCategoryViewModel) -> Bool {
        return lhs.category == rhs.category
    }
}
