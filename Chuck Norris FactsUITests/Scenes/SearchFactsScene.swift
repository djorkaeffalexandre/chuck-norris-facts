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

    init() {
        let app = XCUIApplication()

        searchFactsView = app.otherElements["searchFactsView"]
        searchBarField = app.searchFields["Search"]
    }

}
