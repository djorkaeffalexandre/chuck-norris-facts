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

protocol FactsListViewModelInputs {
    var viewDidAppear: AnyObserver<Void> { get }
    
    var startShareFact: AnyObserver<FactViewModel> { get }
    
    var startSearchFacts: AnyObserver<Void> { get }

    var setSearchTerm: AnyObserver<String> { get }

    var retryAction: AnyObserver<Void> { get }
}

protocol FactsListViewModelOutputs {
    var facts: Observable<[FactsSectionModel]> { get }

    var showShareFact: Observable<FactViewModel> { get }

    var showSearchFacts: Observable<Void> { get }

    var searchTerm: Observable<String> { get }

    var isLoading: ActivityIndicator { get }

    var errors: Observable<FactsListError> { get }
}

final class FactsListViewModel: FactsListViewModelInputs, FactsListViewModelOutputs {
    
    var inputs: FactsListViewModelInputs { return self }

    var outputs: FactsListViewModelOutputs { return self }

    // MARK: - Inputs

    var viewDidAppear: AnyObserver<Void>

    var startShareFact: AnyObserver<FactViewModel>

    var startSearchFacts: AnyObserver<Void>

    var setSearchTerm: AnyObserver<String>

    var retryAction: AnyObserver<Void>

    // MARK: - Outputs

    var facts: Observable<[FactsSectionModel]>

    var showShareFact: Observable<FactViewModel>

    var showSearchFacts: Observable<Void>

    var searchTerm: Observable<String>

    var isLoading: ActivityIndicator

    var errors: Observable<FactsListError>

    init(factsService: FactsServiceType = FactsService()) {
        let loadingIndicator = ActivityIndicator()
        self.isLoading = loadingIndicator

        let viewDidAppearSubject = PublishSubject<Void>()
        self.viewDidAppear = viewDidAppearSubject.asObserver()

        let startShareFactSubject = PublishSubject<FactViewModel>()
        self.startShareFact = startShareFactSubject.asObserver()
        self.showShareFact = startShareFactSubject.asObservable()

        let startSearchFactsSubject = PublishSubject<Void>()
        self.startSearchFacts = startSearchFactsSubject.asObserver()
        self.showSearchFacts = startSearchFactsSubject.asObservable()

        let searchTermSubject = BehaviorSubject<String>(value: "")
        self.setSearchTerm = searchTermSubject.asObserver()
        self.searchTerm = searchTermSubject.asObservable()

        let retryActionSubject = PublishSubject<Void>()
        self.retryAction = retryActionSubject.asObserver()

        let currentErrorSubject = BehaviorSubject<FactsListError?>(value: nil)

        let retrySyncCategories = retryActionSubject.withLatestFrom(currentErrorSubject)
            .compactMap { $0 }
            .filter { $0 == .syncCategories($0.error) }
            .map { _ in () }

        let syncCategoriesError = Observable.merge(viewDidAppearSubject, retrySyncCategories)
            .flatMapLatest { _ in
                factsService.syncCategories()
                    .materialize()
            }
            .compactMap { $0.event.error }
            .map { FactsListError.syncCategories($0) }

        let searchFacts = Observable.combineLatest(viewDidAppearSubject, searchTerm) { _, term in term }
            .flatMapLatest { searchTerm in
                factsService.searchFacts(searchTerm: searchTerm)
                    .trackActivity(loadingIndicator)
                    .materialize()
            }

        let searchFactsError = searchFacts
            .compactMap { $0.event.error }
            .map { FactsListError.searchFacts($0) }

        self.facts = searchFacts
            .compactMap { $0.event.element }
            .map { $0.map { FactViewModel(fact: $0) } }
            .map { [FactsSectionModel(model: "", items: $0)] }

        self.errors = Observable.merge(syncCategoriesError, searchFactsError)
            .do(onNext: currentErrorSubject.onNext)
    }
}
