//
//  SearchEntity.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/25/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation
import RealmSwift

class SearchEntity: Object {
    @objc dynamic var searchTerm = ""
    @objc dynamic var updatedAt = Date()

    override static func primaryKey() -> String? {
        "searchTerm"
    }

    convenience init(searchTerm: String) {
        self.init(value: ["searchTerm": searchTerm])
    }
}
