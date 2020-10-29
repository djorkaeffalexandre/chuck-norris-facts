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
        app.setLaunchArguments([.uiTest, .mockStorage])
        app.launch()

        let factsListScene = FactsListScene()
        factsListScene.searchButton.tap()

        let searchFactsScene = SearchFactsScene()
        searchFactsScene.searchBarField.tap()
        searchFactsScene.searchBarField.typeText("games")

        app.keyboards.buttons["Search"].tap()

        sleep(5)

        XCTAssertEqual(factsListScene.factsTableView.cells.count, 16)
    }

    func test_cancelSearchFacts() throws {
        app.setLaunchArguments([.uiTest, .mockStorage])
        app.launch()

        let factsListScene = FactsListScene()
        factsListScene.searchButton.tap()

        let searchFactsScene = SearchFactsScene()
        searchFactsScene.cancelButton.tap()

        XCTAssertFalse(searchFactsScene.searchFactsView.exists)
    }

    func test_shouldShow8FactCategories() {
        app.setLaunchArguments([.uiTest, .mockStorage])
        app.launch()

        let factsListScene = FactsListScene()
        factsListScene.searchButton.tap()

        let searchFactsScene = SearchFactsScene()
        XCTAssertTrue(searchFactsScene.searchFactsView.exists)

        let suggestionsCells = searchFactsScene.factCategoryCells

        XCTAssertEqual(suggestionsCells.count, 8)
    }

    func test_tapFactCategoryShouldSearchByTerm() {
        app.setLaunchArguments([.uiTest, .mockStorage])
        app.launch()

        let factsListScene = FactsListScene()
        factsListScene.searchButton.tap()

        let searchFactsScene = SearchFactsScene()
        XCTAssertTrue(searchFactsScene.searchFactsView.exists)

        let suggestionsCells = searchFactsScene.factCategoryCells

        let suggestion = suggestionsCells.firstMatch
        XCTAssertTrue(suggestion.exists)

        suggestion.tap()

        sleep(5)

        XCTAssertFalse(searchFactsScene.searchFactsView.exists)
        XCTAssertGreaterThan(factsListScene.factsTableView.cells.count, 0)
    }

    func test_tapPastSearchShouldSearchByTerm() {
        app.setLaunchArguments([.uiTest, .mockStorage])
        app.launch()

        let factsListScene = FactsListScene()
        factsListScene.searchButton.tap()

        let searchFactsScene = SearchFactsScene()
        XCTAssertTrue(searchFactsScene.searchFactsView.exists)

        let searchFactsCells = searchFactsScene.itemsTableView.cells

        let pastSearchCell = searchFactsCells.element(boundBy: 1)
        XCTAssertTrue(pastSearchCell.exists)

        pastSearchCell.tap()

        sleep(5)

        XCTAssertFalse(searchFactsScene.searchFactsView.exists)
        XCTAssertGreaterThan(factsListScene.factsTableView.cells.count, 0)
    }

    func test_tapPastSearchShouldOrderByDate() {
        app.setLaunchArguments([.uiTest, .mockStorage])
        app.launch()

        let factsListScene = FactsListScene()
        factsListScene.searchButton.tap()

        let searchFactsScene = SearchFactsScene()
        XCTAssertTrue(searchFactsScene.searchFactsView.exists)

        let searchFactsCells = searchFactsScene.itemsTableView.cells

        let secondItem = searchFactsCells.element(boundBy: 2)
        XCTAssertTrue(secondItem.exists)

        secondItem.tap()

        let firstItem = searchFactsCells.element(boundBy: 1)
        XCTAssertTrue(firstItem.exists)

        XCTAssertEqual(firstItem.label, secondItem.label)
    }

    func test_pastSearchShouldBeHiddenOnFirstAccess() {
        app.setLaunchArguments([.uiTest, .resetData])
        app.launch()

        let factsListScene = FactsListScene()
        factsListScene.searchButton.tap()

        let searchFactsScene = SearchFactsScene()
        XCTAssertTrue(searchFactsScene.searchFactsView.exists)

        let searchFactsCells = searchFactsScene.itemsTableView.cells

        XCTAssertEqual(searchFactsCells.count, 1)
    }
}
