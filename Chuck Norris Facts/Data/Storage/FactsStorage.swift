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
    // Store a list of categories
    func storeCategories(_ categories: [FactCategory])

    // Retrieve all local stored categories
    func retrieveCategories() -> Observable<[FactCategory]>

    // Store a list of facts
    func storeFacts(_ facts: [Fact])

    // Retrieve local stored facts filtered by a search term
    func retrieveFacts(searchTerm: String) -> Observable<[Fact]>

    // Store a search and it's result
    func storeSearch(searchTerm: String, facts: [Fact])

    // Retrieve all past searches terms
    func retrieveSearches() -> Observable<[String]>
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
            entities = entities.filter("ANY search.searchTerm = %@", searchTerm)
        }

        return Observable.collection(from: entities).map { $0.map { $0.item }}
    }

    func storeSearch(searchTerm: String, facts: [Fact]) {
        try? realm.write {
            let entity = SearchEntity(searchTerm: searchTerm, facts: facts)
            self.realm.add(entity, update: .modified)
        }
    }

    func retrieveSearches() -> Observable<[String]> {
        let entities = realm.objects(SearchEntity.self).sorted(byKeyPath: "updatedAt", ascending: false)
        return Observable.collection(from: entities).map { $0.map { $0.searchTerm } }
    }
}
