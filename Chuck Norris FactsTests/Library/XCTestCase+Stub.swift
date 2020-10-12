//
//  Fact+Extensions.swift
//  Chuck Norris FactsTests
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/12/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation
import XCTest

@testable import Chuck_Norris_Facts

extension XCTestCase {

    func stub<T: Decodable>(_ resource: String, type: T.Type, decoder: JSONDecoder = JSON.decoder) throws -> T? {
        let bundle = Bundle(for: Self.self)

        guard let url = bundle.url(forResource: resource, withExtension: ".json") else {
            return nil
        }

        let data = try Data(contentsOf: url)
        let stub = try decoder.decode(type, from: data)
        return stub
    }
}
