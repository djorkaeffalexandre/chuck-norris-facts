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

    func test_SearchFacts_WhenSearchByTerm_ShouldLoadFacts() throws {
        app.setLaunchArguments([.uiTest, .resetData, .mockStorage, .mockHttp])
        app.launch()

        let factsListScene = FactsListScene()
        factsListScene.searchButton.tap()

        let searchFactsScene = SearchFactsScene()
        searchFactsScene.searchBarField.tap()
        searchFactsScene.searchBarField.typeText("games")

        app.keyboards.buttons["Search"].tap()

        XCTAssertEqual(factsListScene.factsTableView.cells.count, 16)
    }

    func test_SearchFacts_WhenCancelSearch_ShouldCancelSearchFacts() throws {
        app.setLaunchArguments([.uiTest, .mockStorage])
        app.launch()

        let factsListScene = FactsListScene()
        factsListScene.searchButton.tap()

        let searchFactsScene = SearchFactsScene()
        searchFactsScene.cancelButton.tap()

        XCTAssertFalse(searchFactsScene.searchFactsView.exists)
    }

    func test_SearchFacts_WhenViewAppear_ShouldShow8RandomSuggestions() {
        app.setLaunchArguments([.uiTest, .resetData, .mockHttp])
        app.launch()

        let factsListScene = FactsListScene()
        factsListScene.searchButton.tap()

        let searchFactsScene = SearchFactsScene()
        XCTAssertTrue(searchFactsScene.searchFactsView.exists)

        let suggestionsCells = searchFactsScene.factCategoryCells

        XCTAssertEqual(suggestionsCells.count, 8)
    }

    func test_SearchFacts_WhenTapSuggestion_ShouldSearchBySuggestion() {
        app.setLaunchArguments([.uiTest, .mockStorage, .mockHttp])
        app.launch()

        let factsListScene = FactsListScene()
        factsListScene.searchButton.tap()

        let searchFactsScene = SearchFactsScene()
        XCTAssertTrue(searchFactsScene.searchFactsView.exists)

        let suggestionsCells = searchFactsScene.factCategoryCells

        let suggestion = suggestionsCells.firstMatch
        XCTAssertTrue(suggestion.exists)

        suggestion.tap()

        XCTAssertGreaterThan(factsListScene.factsTableView.cells.count, 0)
    }

    func test_SearchFacts_WhenTapPastSearch_ShouldSearchByPastSearch() {
        app.setLaunchArguments([.uiTest, .mockStorage, .mockHttp])
        app.launch()

        let factsListScene = FactsListScene()
        factsListScene.searchButton.tap()

        let searchFactsScene = SearchFactsScene()
        XCTAssertTrue(searchFactsScene.searchFactsView.exists)

        let searchFactsCells = searchFactsScene.itemsTableView.cells

        let pastSearchCell = searchFactsCells.element(boundBy: 1)
        XCTAssertTrue(pastSearchCell.exists)

        pastSearchCell.tap()

        XCTAssertGreaterThan(factsListScene.factsTableView.cells.count, 0)
    }

    func test_SearchFacts_WhenTapPastSearch_ShouldOrderPastSearch() {
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

        factsListScene.searchButton.tap()

        let firstItem = searchFactsCells.element(boundBy: 1)
        XCTAssertTrue(firstItem.exists)

        XCTAssertEqual(firstItem.label, secondItem.label)
    }

    func test_SearchFacts_WhenFirstAccess_ShouldNoHavePastSearches() {
        app.setLaunchArguments([.uiTest, .resetData, .mockHttp])
        app.launch()

        let factsListScene = FactsListScene()
        factsListScene.searchButton.tap()

        let searchFactsScene = SearchFactsScene()
        XCTAssertTrue(searchFactsScene.searchFactsView.exists)

        let searchFactsCells = searchFactsScene.itemsTableView.cells

        XCTAssertEqual(searchFactsCells.count, 1)
    }
}
