//
//  FactCategoryViewModelTests.swift
//  Chuck Norris FactsTests
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/31/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import RxTest

@testable import Chuck_Norris_Facts

class FactCategoryViewModelTests: XCTestCase {

    func test_FactCategoryViewModel_WhenFormat_ShouldHaveTextUppercased() throws {
        let factCategoryStub = try stub("fact-category", type: FactCategory.self)
        let factCategory = try XCTUnwrap(factCategoryStub)

        let factCategoryViewModel = FactCategoryViewModel(category: factCategory)
        XCTAssertEqual(factCategoryViewModel.text, factCategory.text.uppercased())
    }

    func test_FactCategoryViewModel_WhenCompare_ShouldBeEquatable() throws {
        let factCategoryStub = try stub("fact-category", type: FactCategory.self)
        let factCategory = try XCTUnwrap(factCategoryStub)

        let factCategoryViewModelTest = FactCategoryViewModel(category: factCategory)
        let factCategoryViewModel = FactCategoryViewModel(category: factCategory)
        XCTAssertEqual(factCategoryViewModelTest, factCategoryViewModel)
    }

    func test_FactCategoryViewModel_WhenCompare_ShouldBeIdentifiable() throws {
        let factCategoryStub = try stub("fact-category", type: FactCategory.self)
        let factCategory = try XCTUnwrap(factCategoryStub)

        let factCategoryViewModelTest = FactCategoryViewModel(category: factCategory)
        XCTAssertEqual(factCategoryViewModelTest.identity, factCategory.text)
    }
}
