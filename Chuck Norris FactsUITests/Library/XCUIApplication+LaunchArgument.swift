//
//  XCUIApplication+LaunchArgument.swift
//  Chuck Norris FactsUITests
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/29/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation
import XCTest

enum LaunchArgument: String {
    // UI Testing
    case uiTest = "--ui-test"

    // Reset storage
    case resetData = "--reset-data"

    // Mock storage data
    case mockStorage = "--mock-storage"

    // Mock Http Result
    case mockHttp = "--mock-http"

    // Mock Http Error Result
    case mockHttpError = "--mock-http-error"
}

extension XCUIApplication {
    // Set Launch Arguments to App Command Line arguments
    func setLaunchArguments(_ arguments: [LaunchArgument]) {
        launchArguments = arguments.map { $0.rawValue }
    }
}
