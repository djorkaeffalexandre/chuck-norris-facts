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

typealias FactCategoriesSectionModel = AnimatableSectionModel<String, FactCategoryViewModel>

typealias PastSearchesSectionModel = AnimatableSectionModel<String, PastSearchViewModel>

class SearchFactsViewModel {

    // MARK: - Inputs

    let cancel: AnyObserver<Void>

    let searchTerm: AnyObserver<String>

    let searchAction: AnyObserver<Void>

    let viewWillAppear: AnyObserver<Void>

    // MARK: - Outputs

    let categories: Observable<[FactCategoriesSectionModel]>

    let pastSearches: Observable<[PastSearchesSectionModel]>

    let didCancel: Observable<Void>

    let didSearchFacts: Observable<String>

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

        let viewWillAppearSubject = PublishSubject<Void>()
        self.viewWillAppear = viewWillAppearSubject.asObserver()

        self.categories = viewWillAppearSubject
            .flatMapLatest { factsService.retrieveCategories() }
            .map { Array($0.shuffled().prefix(8)) }
            .map { $0.map { FactCategoryViewModel(category: $0) } }
            .map { [FactCategoriesSectionModel(model: "", items: $0)] }

        self.pastSearches = viewWillAppearSubject
            .flatMapLatest { factsService.retrievePastSearches() }
            .map { $0.map { PastSearchViewModel(text: $0) } }
            .map { [PastSearchesSectionModel(model: "", items: $0)] }
    }
}
