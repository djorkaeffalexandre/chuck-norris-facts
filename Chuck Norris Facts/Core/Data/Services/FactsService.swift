//
//  FactsService.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/20/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import RxSwift

protocol FactsServiceType {

    // Search Facts on Chuck Norris API
    func searchFacts(searchTerm: String) -> Observable<[Fact]>

    // Sync local stored Categories with Chuck Norris API Categories
    func syncCategories() -> Observable<Void>

    // Retrieve local stored Categories
    func retrieveCategories() -> Observable<[FactCategory]>

    // Retrieve local stored Past Searches
    func retrievePastSearches() -> Observable<[String]>
}

struct FactsService: FactsServiceType {

    private var provider: APIProvider<FactsAPI>
    private var storage: FactsStorageType
    private var scheduler: SchedulerType?

    init(
        provider: APIProvider<FactsAPI> = APIProvider<FactsAPI>(),
        storage: FactsStorageType = FactsStorage(),
        scheduler: SchedulerType? = nil
    ) {
        self.provider = provider
        self.storage = storage
        self.scheduler = scheduler
    }

    func searchFacts(searchTerm: String) -> Observable<[Fact]> {
        guard !searchTerm.isEmpty else { return .just([]) }

        return provider.rx
            .request(.searchFacts(searchTerm: searchTerm))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .observeOn(self.scheduler ?? MainScheduler.asyncInstance)
            .map(SearchFactsResponse.self, using: JSON.decoder)
            .map { $0.facts }
            .do(onNext: { _ in
                self.storage.storeSearch(searchTerm: searchTerm)
            })
    }

    func syncCategories() -> Observable<Void> {
        storage.retrieveCategories()
            .flatMapLatest { categories -> Observable<Void> in
                guard categories.isEmpty else { return Observable<Void>.just(()) }

                return self.provider.rx
                    .request(.getCategories)
                    .asObservable()
                    .filterSuccessfulStatusCodes()
                    .observeOn(self.scheduler ?? MainScheduler.asyncInstance)
                    .map([FactCategory].self, using: JSON.decoder)
                    .map { self.storage.storeCategories($0) }
                    .mapToVoid()
            }
    }

    func retrieveCategories() -> Observable<[FactCategory]> {
        storage.retrieveCategories()
    }

    func retrievePastSearches() -> Observable<[String]> {
        storage.retrieveSearches()
    }
}
