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

    func test_FactsList_WhenFirstAccess_ShouldShowEmptyView() throws {
        app.setLaunchArguments([.uiTest, .resetData])
        app.launch()

        let factsListScene = FactsListScene()

        XCTAssertTrue(factsListScene.emptyListView.exists)
        XCTAssertTrue(factsListScene.emptyListLabelView.exists)
    }

    func test_FactsList_WhenShareFact_ShouldShowShareActivity() {
        app.setLaunchArguments([.uiTest, .mockStorage, .mockHttp])
        app.launch()

        let factsListScene = FactsListScene()

        let searchFactsScene = SearchFactsScene()
        let searchFactsButton = factsListScene.searchButton
        XCTAssertTrue(searchFactsButton.exists)

        searchFactsButton.firstMatch.tap()

        searchFactsScene.searchBarField.tap()
        searchFactsScene.searchBarField.typeText("games")

        app.keyboards.buttons["Search"].tap()

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

    func test_FactsList_WhenTapSearch_ShouldShowSearchFacts() {
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

    func test_FactsList_WhenSearchFails_ShouldShowErrorView() {
        app.setLaunchArguments([.uiTest, .mockHttpError])
        app.launch()

        let factsListScene = FactsListScene()
        let searchFactsButton = factsListScene.searchButton

        let searchFactsScene = SearchFactsScene()

        XCTAssertTrue(searchFactsButton.exists)

        searchFactsButton.firstMatch.tap()

        searchFactsScene.searchBarField.tap()
        searchFactsScene.searchBarField.typeText("games")

        app.keyboards.buttons["Search"].tap()

        XCTAssertTrue(factsListScene.errorView.exists)
        XCTAssertTrue(factsListScene.retryButton.exists)
    }
}
