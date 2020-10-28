//
//  SuggestionsViewModel.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/26/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import RxSwift

struct SuggestionsViewModel {

    // MARK: - Inputs

    let suggestion: AnyObserver<String>

    let selectAction: AnyObserver<Void>

    // MARK: - Outputs

    let suggestions: Observable<[SuggestionsSectionModel]>

    let didSelectSuggestion: Observable<String>

    init(suggestions: [SuggestionsSectionModel]) {
        let suggestionsSubject = BehaviorSubject<[SuggestionsSectionModel]>(value: [])
        self.suggestions = suggestionsSubject.asObserver()

        suggestionsSubject.onNext(suggestions)

        let suggestionSubject = BehaviorSubject<String>(value: "")
        self.suggestion = suggestionSubject.asObserver()

        let selectActionSubject = PublishSubject<Void>()
        self.selectAction = selectActionSubject.asObserver()

        self.didSelectSuggestion = selectActionSubject
            .withLatestFrom(suggestionSubject)
            .filter { !$0.isEmpty }
    }
}
