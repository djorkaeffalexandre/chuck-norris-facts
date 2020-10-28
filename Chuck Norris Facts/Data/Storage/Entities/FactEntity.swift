//
//  FactEntity.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/23/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation
import RealmSwift

class FactEntity: Object {
    @objc dynamic var id = ""
    @objc dynamic var url = ""
    @objc dynamic var value = ""
    @objc dynamic var iconUrl = ""

    let categories = List<FactCategoryEntity>()

    let search = LinkingObjects(fromType: SearchEntity.self, property: "facts")

    override static func primaryKey() -> String? {
        "id"
    }

    convenience init(fact: Fact) {
        self.init(value: [
            "id": fact.id,
            "url": fact.url ?? "",
            "value": fact.value,
            "iconUrl": fact.iconUrl,
            "categories": fact.categories.map(FactCategoryEntity.init)
        ])
    }

    var item: Fact {
        Fact(id: id, value: value, url: url, iconUrl: iconUrl, categories: categories.map { $0.item })
    }
}
