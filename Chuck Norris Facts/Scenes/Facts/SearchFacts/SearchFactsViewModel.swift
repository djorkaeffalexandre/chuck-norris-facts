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

    // MARK: - Outputs

    let didCancel: Observable<Void>

    init(factsService: FactsService = FactsService()) {
        let cancelSubject = PublishSubject<Void>()
        self.cancel = cancelSubject.asObserver()
        self.didCancel = cancelSubject.asObservable()
    }
}
