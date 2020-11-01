//
//  SuggestionsViewModel.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/26/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import RxSwift

protocol SuggestionsViewModelInputs {
    var suggestion: AnyObserver<String> { get }

    var selectAction: AnyObserver<Void> { get }
}

protocol SuggestionsViewModelOutputs {
    var suggestions: Observable<[SuggestionsSectionModel]> { get }

    var didSelectSuggestion: Observable<String> { get }
}

struct SuggestionsViewModel: SuggestionsViewModelInputs, SuggestionsViewModelOutputs {

    var inputs: SuggestionsViewModelInputs { return self }

    var outputs: SuggestionsViewModelOutputs { return self }

    // MARK: - Inputs

    var suggestion: AnyObserver<String>

    var selectAction: AnyObserver<Void>

    // MARK: - Outputs

    var suggestions: Observable<[SuggestionsSectionModel]>

    var didSelectSuggestion: Observable<String>

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
