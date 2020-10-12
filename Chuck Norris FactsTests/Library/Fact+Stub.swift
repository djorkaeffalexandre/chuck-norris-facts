//
//  Fact+Extensions.swift
//  Chuck Norris FactsTests
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/12/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation

@testable import Chuck_Norris_Facts

extension Fact {
    static func stub() -> Fact {
        Fact(
            id: UUID().uuidString,
            value: "Chuck Norris doesn't have aids. But he gives it to people anyways.",
            url: "",
            iconUrl: "https://assets.chucknorris.host/img/avatar/chuck-norris.png"
        )
    }
}
