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
    // Call when view did appear to syncCategories
    var viewDidAppear: AnyObserver<Void> { get }

    // Call when user start to share a fact
    var startShareFact: AnyObserver<FactViewModel> { get }

    // Call to show SearchFacts scene
    var startSearchFacts: AnyObserver<Void> { get }

    // Call to set SearchTerm to be used on search
    var setSearchTerm: AnyObserver<String> { get }

    // Call to retry a syncCategories action
    var retryAction: AnyObserver<Void> { get }
}

protocol FactsListViewModelOutputs {
    // Emmits an array of FactsSectionModel to bind on tableView
    var facts: Observable<[FactsSectionModel]> { get }

    // Emmits an FactViewModel to be shared
    var showShareFact: Observable<FactViewModel> { get }

    // Emmits an event to show SearchFacts scene
    var showSearchFacts: Observable<Void> { get }

    // Emmits an string to be used as a search query and check empty state
    var searchTerm: Observable<String> { get }

    // Emmits an ActivityIndicator to check if there is a facts search happening
    var isLoading: ActivityIndicator { get }

    // Emmits an FactsListError to be shown
    var errors: Observable<FactsListErrorViewModel> { get }
}

final class FactsListViewModel: FactsListViewModelInputs, FactsListViewModelOutputs {

    var inputs: FactsListViewModelInputs { self }

    var outputs: FactsListViewModelOutputs { self }

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

    var errors: Observable<FactsListErrorViewModel>

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
            .mapToVoid()

        let syncCategoriesError = Observable.merge(viewDidAppearSubject, retrySyncCategories)
            .flatMapLatest { _ in
                factsService.syncCategories()
                    .materialize()
            }
            .errors()
            .map { FactsListError.syncCategories($0) }

        let searchFacts = searchTermSubject
            .flatMapLatest { searchTerm in
                factsService.searchFacts(searchTerm: searchTerm)
                    .trackActivity(loadingIndicator)
                    .materialize()
            }

        let searchFactsError = searchFacts.errors()
            .map { FactsListError.searchFacts($0) }

        self.facts = searchFacts.elements()
            .map { $0.map { FactViewModel(fact: $0) } }
            .map { [FactsSectionModel(model: "", items: $0)] }

        self.errors = Observable.merge(syncCategoriesError, searchFactsError)
            .do(onNext: currentErrorSubject.onNext)
            .map { FactsListErrorViewModel(factsListError: $0) }
    }
}
