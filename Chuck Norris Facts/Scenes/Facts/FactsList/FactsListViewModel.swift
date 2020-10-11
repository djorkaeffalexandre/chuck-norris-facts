//
//  FactsListViewModel.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/10/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation
import RxSwift

final class FactsListViewModel {

    // MARK: - Inputs

    let startShareFact: AnyObserver<FactViewModel>

    // MARK: - Outputs

    let facts: Observable<[FactViewModel]>

    let showShareFact: Observable<FactViewModel>

    init(factsService: FactsService = FactsService()) {
        self.facts = factsService.searchFacts(query: "")

        let startShareFactSubject = PublishSubject<FactViewModel>()
        self.startShareFact = startShareFactSubject.asObserver()
        self.showShareFact = startShareFactSubject.asObservable()
    }
}
