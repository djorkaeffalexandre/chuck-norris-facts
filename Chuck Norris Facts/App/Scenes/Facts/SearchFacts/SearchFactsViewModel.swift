//
//  SearchFactsViewModel.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/13/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift

typealias PastSearchesSectionModel = AnimatableSectionModel<String, PastSearchViewModel>

protocol SearchFactsViewModelInputs {
    // Call when search facts scene is cancelled
    var cancel: AnyObserver<Void> { get }

    // Call when search term changes
    var searchTerm: AnyObserver<String> { get }

    // Call when a search is started (textDidEndEditing)
    var searchAction: AnyObserver<Void> { get }

    // Call when view will appear to load categories and pastSearches
    var viewWillAppear: AnyObserver<Void> { get }

    // Call when a item is selected to start a new search
    var selectItem: AnyObserver<String> { get }
}

protocol SearchFactsViewModelOutputs {
    // Emmits an event to SearchFacts coordinator dismiss SearchFacts Scene
    var didCancel: Observable<Void> { get }

    // Emmits an string to start a new search when a term is sent by searchAction
    var didSearchFacts: Observable<String> { get }

    // Emmits an string to start a new search when a item is selected
    var didSelectItem: Observable<String> { get }

    // Emmits an array of SearchFacts TableView sections to bind on tableView
    var items: Observable<[SearchFactsTableViewSection]> { get }
}

final class SearchFactsViewModel: SearchFactsViewModelInputs, SearchFactsViewModelOutputs {

    var inputs: SearchFactsViewModelInputs { self }

    var outputs: SearchFactsViewModelOutputs { self }

    // MARK: - Inputs

    var cancel: AnyObserver<Void>

    var searchTerm: AnyObserver<String>

    var searchAction: AnyObserver<Void>

    var viewWillAppear: AnyObserver<Void>

    var selectItem: AnyObserver<String>

    // MARK: - Outputs

    var didCancel: Observable<Void>

    var didSearchFacts: Observable<String>

    var didSelectItem: Observable<String>

    var items: Observable<[SearchFactsTableViewSection]>

    init(factsService: FactsServiceType = FactsService()) {
        let cancelSubject = PublishSubject<Void>()
        self.cancel = cancelSubject.asObserver()
        self.didCancel = cancelSubject.asObservable()

        let searchTermSubject = BehaviorSubject<String>(value: "")
        self.searchTerm = searchTermSubject.asObserver()

        let searchActionSubject = PublishSubject<Void>()
        self.searchAction = searchActionSubject.asObserver()

        self.didSearchFacts = searchActionSubject
            .withLatestFrom(searchTermSubject)
            .filter { !$0.isEmpty }

        let selectItemSubject = BehaviorSubject<String>(value: "")
        self.selectItem = selectItemSubject.asObserver()

        self.didSelectItem = selectItemSubject
            .filter { !$0.isEmpty }

        let viewWillAppearSubject = PublishSubject<Void>()
        self.viewWillAppear = viewWillAppearSubject.asObserver()

        let categories = viewWillAppearSubject
            .flatMapLatest { factsService.retrieveCategories() }
            .map { Array($0.shuffled().prefix(8)) }

        let suggestions = categories
            .map { $0.map { FactCategoryViewModel(category: $0) } }
            .map { [SearchFactsTableViewItem.SuggestionsTableViewItem(suggestions: $0)] }
            .map { suggestions -> SearchFactsTableViewSection in .SuggestionsSection(items: suggestions) }

        let pastSearches = viewWillAppearSubject
            .flatMapLatest { factsService.retrievePastSearches() }
            .map { $0.map { PastSearchViewModel(text: $0) } }
            .map { $0.map { SearchFactsTableViewItem.PastSearchTableViewItem(pastSearch: $0) } }
            .map { pastSearches -> SearchFactsTableViewSection in .PastSearchesSection(items: pastSearches)}

        self.items = Observable.combineLatest(suggestions, pastSearches) { suggestions, pastSearches in
                [suggestions, pastSearches]
            }
            .map { $0.filter { !$0.isEmpty } }
    }
}
