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

    func test_FactViewModel_WhenWithoutCategory_ShouldHaveCategoryUncategorized() throws {
        let factStub = try stub("short-fact", type: Fact.self)
        let fact = try XCTUnwrap(factStub)

        let factViewModel = FactViewModel(fact: fact)
        XCTAssertEqual(factViewModel.category, L10n.FactCategory.uncategorized)
    }

    func test_FactViewModel_WhenCompare_ShouldBeEquatable() throws {
        let factStub = try stub("short-fact", type: Fact.self)
        let fact = try XCTUnwrap(factStub)

        let factViewModelTest = FactViewModel(fact: fact)
        let factViewModel = FactViewModel(fact: fact)
        XCTAssertEqual(factViewModelTest, factViewModel)
    }

    func test_FactViewModel_WhenCompare_ShouldBeIdentifiable() throws {
        let factStub = try stub("short-fact", type: Fact.self)
        let fact = try XCTUnwrap(factStub)

        let factViewModelTest = FactViewModel(fact: fact)
        XCTAssertEqual(factViewModelTest.identity, fact.id)
    }
}
