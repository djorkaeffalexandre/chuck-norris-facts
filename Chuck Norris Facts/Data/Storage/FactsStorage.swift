//
//  FactsStorage.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/20/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm

protocol FactsStorageType {
    func storeCategories(_ categories: [FactCategory])

    func retrieveCategories() -> Observable<[FactCategory]>

    func storeFacts(_ facts: [Fact])

    func retrieveFacts(searchTerm: String) -> Observable<[Fact]>
}

final class FactsStorage: FactsStorageType {
    private let realm: Realm!

    init(realm: Realm? = nil) {
        self.realm = realm ?? (try? Realm())
    }

    func storeCategories(_ categories: [FactCategory]) {
        try? realm.write {
            let entities = categories.map(FactCategoryEntity.init)
            self.realm.add(entities, update: .modified)
        }
    }

    func retrieveCategories() -> Observable<[FactCategory]> {
        let entities = realm.objects(FactCategoryEntity.self)
        return Observable.collection(from: entities).map { $0.map { $0.item } }
    }

    func storeFacts(_ facts: [Fact]) {
        try? realm.write {
            let entities = facts.map(FactEntity.init)
            self.realm.add(entities, update: .modified)
        }
    }

    func retrieveFacts(searchTerm: String) -> Observable<[Fact]> {
        var entities = realm.objects(FactEntity.self)

        if !searchTerm.isEmpty {
            entities = entities.filter("value CONTAINS %@", searchTerm)
        }

        return Observable.collection(from: entities).map { $0.map { $0.item }}
    }
}
