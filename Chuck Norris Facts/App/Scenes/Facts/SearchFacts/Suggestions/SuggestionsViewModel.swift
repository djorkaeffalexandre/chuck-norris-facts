//
//  SuggestionsViewModel.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/26/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import RxSwift
import RxDataSources

protocol SuggestionsViewModelInputs {
    var selectSuggestion: AnyObserver<String> { get }
}

protocol SuggestionsViewModelOutputs {
    var suggestions: Observable<[SuggestionsSectionModel]> { get }

    var didSelectSuggestion: Observable<String> { get }
}

struct SuggestionsViewModel: SuggestionsViewModelInputs, SuggestionsViewModelOutputs {

    var inputs: SuggestionsViewModelInputs { self }

    var outputs: SuggestionsViewModelOutputs { self }

    // MARK: - Inputs

    var selectSuggestion: AnyObserver<String>

    // MARK: - Outputs

    var suggestions: Observable<[SuggestionsSectionModel]>

    var didSelectSuggestion: Observable<String>

    init(suggestions: [FactCategoryViewModel]) {
        let suggestionsSubject = BehaviorSubject<[SuggestionsSectionModel]>(value: [])
        self.suggestions = suggestionsSubject.asObserver()

        suggestionsSubject.onNext([SuggestionsSectionModel(model: "", items: suggestions)])

        let selectSuggestionSubject = BehaviorSubject<String>(value: "")
        self.selectSuggestion = selectSuggestionSubject.asObserver()

        self.didSelectSuggestion = selectSuggestionSubject
            .filter { !$0.isEmpty }
    }
}
