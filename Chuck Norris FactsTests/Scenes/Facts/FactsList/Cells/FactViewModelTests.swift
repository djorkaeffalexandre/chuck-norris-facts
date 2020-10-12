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

    func test_factViewModelIsEquatable() throws {
        let fact = Fact.stub()

        let factViewModelTest = FactViewModel(fact: fact)
        let factViewModel = FactViewModel(fact: fact)
        XCTAssertEqual(factViewModelTest, factViewModel)
    }

    func test_factViewModelIsIdentifiable() throws {
        let fact = Fact.stub()

        let factViewModelTest = FactViewModel(fact: fact)
        XCTAssertEqual(factViewModelTest.identity, fact.value)
    }
}
