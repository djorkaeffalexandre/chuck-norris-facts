//
//  SearchFactsViewModel.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/13/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import RxSwift

class SearchFactsViewModel {

    // MARK: - Inputs

    let cancel: AnyObserver<Void>

    let searchTerm: AnyObserver<String>

    let searchAction: AnyObserver<Void>

    // MARK: - Outputs

    let didCancel: Observable<Void>

    let didSearchFacts: Observable<String>

    init() {
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
    }
}
