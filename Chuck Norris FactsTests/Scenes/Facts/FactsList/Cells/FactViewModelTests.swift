//
//  FactViewModel.swift
//  Chuck Norris FactsTests
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/11/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import RxTest

@testable import Chuck_Norris_Facts

class FactViewModelTests: XCTestCase {

    func test_factTextSize_isAdjustedToContentSize() throws {
        guard let file = Bundle.main.url(forResource: "large-fact", withExtension: ".json") else {
            return
        }

        let data = try Data(contentsOf: file)

        let fact = try JSON.decoder.decode(Fact.self, from: data)
        let factViewModel = FactViewModel(fact: fact)

        XCTAssertEqual(factViewModel.textSize, TextSize.large)
    }
}
