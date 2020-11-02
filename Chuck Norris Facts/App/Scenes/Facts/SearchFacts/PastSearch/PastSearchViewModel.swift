//
//  PastSearchViewModel.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/25/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation
import RxDataSources

typealias PastSearchesSectionModel = AnimatableSectionModel<String, PastSearchViewModel>

struct PastSearchViewModel {
    let text: String
}

extension PastSearchViewModel: IdentifiableType {
    var identity: String {
        text
    }
}

extension PastSearchViewModel: Equatable {
    static func == (lhs: PastSearchViewModel, rhs: PastSearchViewModel) -> Bool {
        return lhs.text == rhs.text
    }
}
