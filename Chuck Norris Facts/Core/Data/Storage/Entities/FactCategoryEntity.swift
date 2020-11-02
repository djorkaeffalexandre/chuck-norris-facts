//
//  FactCategoryEntity.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/20/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation
import RealmSwift

class FactCategoryEntity: Object {
    @objc dynamic var text = ""

    override static func primaryKey() -> String? {
        "text"
    }

    convenience init(category: FactCategory) {
        self.init(value: ["text": category.text])
    }

    var item: FactCategory {
        FactCategory(text: text)
    }
}
