//
//  Data+Stub.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/21/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation

extension Data {

    static func stub(_ resource: String) -> Data? {
        guard let url = Bundle.main.url(forResource: resource, withExtension: ".json") else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            return nil
        }
    }

    static func stub<T: Decodable>(_ resource: String, type: T.Type, decoder: JSONDecoder = JSON.decoder) -> T? {
        guard let url = Bundle.main.url(forResource: resource, withExtension: ".json") else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let stub = try decoder.decode(type, from: data)
            return stub
        } catch {
            return nil
        }
    }
}
