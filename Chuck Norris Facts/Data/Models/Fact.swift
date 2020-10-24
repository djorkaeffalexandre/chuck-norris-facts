//
//  Fact.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/10/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation

struct Fact: Decodable {
    let id: String
    let value: String
    let url: String?
    let iconUrl: String

    init(id: String, value: String, url: String?, iconUrl: String) {
        self.id = id
        self.value = value
        self.url = url
        self.iconUrl = iconUrl
    }
}
