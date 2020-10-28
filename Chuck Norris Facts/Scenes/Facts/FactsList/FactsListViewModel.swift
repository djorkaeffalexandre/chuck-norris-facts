//
//  FactsListViewModel.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/10/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

typealias FactsSectionModel = AnimatableSectionModel<String, FactViewModel>

final class FactsListViewModel {

    // MARK: - Inputs

    let viewDidAppear: AnyObserver<Void>

    let startShareFact: AnyObserver<FactViewModel>

    let startSearchFacts: AnyObserver<Void>

    let setSearchTerm: AnyObserver<String>

    let retryError: AnyObserver<Void>

    // MARK: - Outputs

    let facts: Observable<[FactsSectionModel]>

    let showShareFact: Observable<FactViewModel>

    let showSearchFacts: Observable<Void>

    let searchTerm: Observable<String>

    let isLoading: ActivityIndicator

    let syncCategories: Observable<Void>

    init(factsService: FactsServiceType = FactsService()) {
        let loadingIndicator = ActivityIndicator()
        self.isLoading = loadingIndicator

        let viewDidAppearSubject = PublishSubject<Void>()
        self.viewDidAppear = viewDidAppearSubject.asObserver()

        let retryErrorSubject = PublishSubject<Void>()
        self.retryError = retryErrorSubject.asObserver()

        let startShareFactSubject = PublishSubject<FactViewModel>()
        self.startShareFact = startShareFactSubject.asObserver()
        self.showShareFact = startShareFactSubject.asObservable()

        let startSearchFactsSubject = PublishSubject<Void>()
        self.startSearchFacts = startSearchFactsSubject.asObserver()
        self.showSearchFacts = startSearchFactsSubject.asObservable()

        let searchTermSubject = BehaviorSubject<String>(value: "")
        self.setSearchTerm = searchTermSubject.asObserver()
        self.searchTerm = searchTermSubject.asObservable()

        self.syncCategories = Observable.combineLatest(viewDidAppearSubject, retryErrorSubject)
            .flatMapLatest { _, _ -> Observable<Void> in
                factsService.syncCategories()
            }

        _ = searchTermSubject.asObservable()
            .filter { !$0.isEmpty }
            .flatMapLatest { searchTerm -> Observable<Void> in
                return factsService.searchFacts(searchTerm: searchTerm)
                    .trackActivity(loadingIndicator)
            }
            .subscribe(onNext: {})

        self.facts = Observable.combineLatest(viewDidAppearSubject, searchTermSubject)
            .flatMapLatest { _, searchTerm -> Observable<[Fact]> in
                if CommandLine.arguments.contains("--search-facts") {
                    let bundle = Bundle(for: Self.self)
                    guard let url = bundle.url(forResource: "search-facts", withExtension: ".json") else {
                        return .just([])
                    }
                    let data = try Data(contentsOf: url)
                    let stub = try JSON.decoder.decode(SearchFactsResponse.self, from: data)
                    let facts = stub.facts.shuffled().prefix(10)
                    return .just(Array(facts))
                }
                if CommandLine.arguments.contains("--empty-facts") {
                    return .just([])
                }
                let facts = factsService.retrieveFacts(searchTerm: searchTerm)
                if searchTerm.isEmpty {
                    return facts.map { Array($0.shuffled().prefix(10)) }
                }
                return facts
            }
            .map { $0.map { FactViewModel(fact: $0) } }
            .map { [FactsSectionModel(model: "", items: $0)] }
    }
}
