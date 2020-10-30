//
//  APITask.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/30/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation

// Represents an HTTP task.
enum APITask {

    // A request with no additional data.
    case requestPlain

    // A requests body set with encoded parameters.
    case requestParameters(parameters: [String: Any])
}
