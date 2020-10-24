//
//  SearchFactsUITests.swift
//  Chuck Norris FactsUITests
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/20/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation
import XCTest

final class SearchFactsUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
    }

    func test_searchFactsUsingSearchBar() throws {
        app.launch()

        let factsListScene = FactsListScene()
        factsListScene.searchButton.tap()

        let searchFactsScene = SearchFactsScene()
        searchFactsScene.searchBarField.tap()
        searchFactsScene.searchBarField.typeText("games")

        app.keyboards.buttons["Search"].tap()

        sleep(5)

        XCTAssertEqual(factsListScene.factsTableView.cells.count, 15)
    }

    func test_cancelSearchFacts() throws {
        app.launch()

        let factsListScene = FactsListScene()
        factsListScene.searchButton.tap()

        let searchFactsScene = SearchFactsScene()
        searchFactsScene.cancelButton.tap()

        XCTAssertFalse(searchFactsScene.searchFactsView.exists)
    }

    func test_shouldShow8FactCategories() {
        app.launch()

        let factsListScene = FactsListScene()
        factsListScene.searchButton.tap()

        let searchFactsScene = SearchFactsScene()
        XCTAssertTrue(searchFactsScene.searchFactsView.exists)

        XCTAssertEqual(searchFactsScene.factsCategoriesCollection.cells.count, 8)
    }

    func test_tapFactCategoryShouldSearchByTerm() {
        app.launch()

        let factsListScene = FactsListScene()
        factsListScene.searchButton.tap()

        let searchFactsScene = SearchFactsScene()
        XCTAssertTrue(searchFactsScene.searchFactsView.exists)

        let firstFactCategory = searchFactsScene.factsCategoriesCollection.cells.firstMatch
        XCTAssertTrue(firstFactCategory.exists)

        firstFactCategory.tap()
        XCTAssertFalse(searchFactsScene.searchFactsView.exists)

        sleep(5)

        XCTAssertGreaterThan(factsListScene.factsTableView.cells.count, 0)
    }
}
