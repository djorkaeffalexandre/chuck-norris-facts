//
//  FactsService.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/20/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import RxSwift
import Moya

protocol FactsServiceType {

    // Search Facts on Chuck Norris API
    func searchFacts(searchTerm: String) -> Observable<Void>

    // Sync local stored Categories with Chuck Norris API Categories
    func syncCategories() -> Observable<Void>

    // Retrieve local stored Categories
    func retrieveCategories() -> Observable<[FactCategory]>

    // Retrieve local stored Facts
    func retrieveFacts(searchTerm: String) -> Observable<[Fact]>

    // Retrieve local stored Past Searches
    func retrievePastSearches() -> Observable<[String]>
}

struct FactsService: FactsServiceType {

    private var provider: MoyaProvider<FactsAPI>
    private var storage: FactsStorageType

    init(provider: MoyaProvider<FactsAPI> = MoyaProvider<FactsAPI>(), storage: FactsStorageType = FactsStorage()) {
        self.provider = provider
        self.storage = storage
    }

    func searchFacts(searchTerm: String) -> Observable<Void> {
        provider.rx
            .request(.searchFacts(searchTerm: searchTerm))
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .map(SearchFactsResponse.self, using: JSON.decoder)
            .map { $0.facts }
            .map { self.storage.storeSearch(searchTerm: searchTerm, facts: $0) }
            .map { () }
    }

    func syncCategories() -> Observable<Void> {
        provider.rx
            .request(.getCategories)
            .asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .map([FactCategory].self, using: JSON.decoder)
            .map { self.storage.storeCategories($0) }
            .map { () }
    }

    func retrieveCategories() -> Observable<[FactCategory]> {
        storage.retrieveCategories()
    }

    func retrieveFacts(searchTerm: String) -> Observable<[Fact]> {
        storage.retrieveFacts(searchTerm: searchTerm)
    }

    func retrievePastSearches() -> Observable<[String]> {
        storage.retrieveSearches()
    }
}
