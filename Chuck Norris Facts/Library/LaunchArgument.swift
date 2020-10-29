//
//  LaunchArgument.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/29/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

enum LaunchArgument: String {
    // UI Testing
    case uiTest = "--ui-test"

    // Reset storage
    case resetData = "--reset-data"

    // Mock storage data
    case mockStorage = "--mock-storage"

    // Mock Http Error Result
    case mockHttpError = "--mock-http-error"

    // Check if there is an argument on CommandLine arguments
    static func check(_ argument: LaunchArgument) -> Bool {
        CommandLine.arguments.contains(argument.rawValue)
    }
}
