//
//  Data+Stub.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/21/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation

extension Data {

    static func stub(_ resource: String) throws -> Data? {
        guard let url = Bundle.main.url(forResource: resource, withExtension: ".json") else {
            return nil
        }

        let data = try Data(contentsOf: url)
        return data
    }
}
