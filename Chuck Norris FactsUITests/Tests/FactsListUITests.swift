//
//  FactsListTests.swift
//  Chuck Norris FactsUITests
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/12/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation
import XCTest

final class FactsListUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
    }

    func test_showEmptyView() throws {
        app.setLaunchArguments([.uiTest, .resetData])
        app.launch()

        let factsListScene = FactsListScene()

        XCTAssertTrue(factsListScene.emptyListView.exists)
        XCTAssertTrue(factsListScene.emptyListLabelView.exists)
    }

    func test_show10RandomFacts() {
        app.setLaunchArguments([.uiTest, .mockStorage])
        app.launch()

        let factsListScene = FactsListScene()

        XCTAssertEqual(factsListScene.factsTableView.cells.count, 10)
    }

    func test_shareFact() {
        app.setLaunchArguments([.uiTest, .mockStorage])
        app.launch()

        let factsListScene = FactsListScene()
        let firstFactCell = factsListScene.factsTableView.firstMatch
        let shareFactButton = firstFactCell.buttons["shareFactButton"]
        XCTAssertTrue(shareFactButton.exists)

        shareFactButton.firstMatch.tap()

        let shareActivity = app.otherElements["ActivityListView"]
        XCTAssertTrue(shareActivity.waitForExistence(timeout: 1))

        let shareActivityClose = shareActivity.buttons["Close"]
        shareActivityClose.tap()

        XCTAssertFalse(shareActivity.waitForExistence(timeout: 1))
    }

    func test_searchFacts() {
        app.setLaunchArguments([.uiTest, .mockStorage])
        app.launch()

        let factsListScene = FactsListScene()
        let searchFactsButton = factsListScene.searchButton

        let searchFactsScene = SearchFactsScene()
        let searchFactsView = searchFactsScene.searchFactsView

        XCTAssertTrue(searchFactsButton.exists)

        searchFactsButton.firstMatch.tap()

        XCTAssertTrue(searchFactsView.exists)
    }
}
