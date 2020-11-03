//
//  SearchFactsScene.swift
//  Chuck Norris FactsUITests
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/20/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation
import XCTest

struct SearchFactsScene {

    let searchFactsView: XCUIElement
    let searchBarField: XCUIElement
    let cancelButton: XCUIElement
    let itemsTableView: XCUIElement

    init() {
        let app = XCUIApplication()

        searchFactsView = app.otherElements["searchFactsView"]
        searchBarField = app.searchFields["Search"]
        cancelButton = app.navigationBars.buttons["cancelButton"]
        itemsTableView = app.tables["itemsTableView"]
    }

}

extension SearchFactsScene {
    var factCategoryCells: XCUIElementQuery {
        itemsTableView.cells
            .children(matching: .other)
            .matching(identifier: "factCategoryCell")
    }
}
