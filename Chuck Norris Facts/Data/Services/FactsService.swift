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

let errorEndpointClosure = { (target: FactsAPI) -> Endpoint in
    Endpoint(
        url: URL(target: target).absoluteString,
        sampleResponseClosure: { .networkResponse(500, Data()) },
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers
    )
}

let mockEndpointClosure = {  (target: FactsAPI) -> Endpoint in
   Endpoint(
       url: URL(target: target).absoluteString,
       sampleResponseClosure: { .networkResponse(200, target.sampleData) },
       method: target.method,
       task: target.task,
       httpHeaderFields: target.headers
   )
}

struct FactsService: FactsServiceType {

    private var provider: MoyaProvider<FactsAPI>
    private var storage: FactsStorageType
    private var scheduler: SchedulerType?

    init(
        provider: MoyaProvider<FactsAPI> = MoyaProvider<FactsAPI>(),
        storage: FactsStorageType = FactsStorage(),
        scheduler: SchedulerType? = nil
    ) {
        if LaunchArgument.check(.mockHttpError) {
            self.provider = MoyaProvider<FactsAPI>(
                endpointClosure: errorEndpointClosure,
                stubClosure: MoyaProvider.immediatelyStub
            )
        } else if LaunchArgument.check(.mockHttp) {
            self.provider = MoyaProvider<FactsAPI>(
                endpointClosure: mockEndpointClosure,
                stubClosure: MoyaProvider.immediatelyStub
            )
        } else {
            self.provider = provider
        }

        self.storage = storage
        self.scheduler = scheduler
    }

    func searchFacts(searchTerm: String) -> Observable<Void> {
        provider.rx
            .request(.searchFacts(searchTerm: searchTerm))
            .asObservable()
            .observeOn(scheduler ?? MainScheduler.asyncInstance)
            .map(SearchFactsResponse.self, using: JSON.decoder)
            .map { $0.facts }
            .map { self.storage.storeSearch(searchTerm: searchTerm, facts: $0) }
            .map { () }
    }

    func syncCategories() -> Observable<Void> {
        storage.retrieveCategories()
            .flatMapLatest { categories -> Observable<Void> in
                guard categories.isEmpty else { return Observable<Void>.just(()) }

                return self.provider.rx
                    .request(.getCategories)
                    .asObservable()
                    .observeOn(self.scheduler ?? MainScheduler.asyncInstance)
                    .map([FactCategory].self, using: JSON.decoder)
                    .map { self.storage.storeCategories($0) }
                    .map { () }
            }
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
