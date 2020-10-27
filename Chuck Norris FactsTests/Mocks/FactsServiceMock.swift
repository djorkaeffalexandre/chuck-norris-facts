//
//  FactsServiceMock.swift
//  Chuck Norris FactsTests
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/12/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation
import RxSwift

@testable import Chuck_Norris_Facts

final class FactsServiceMock: FactsServiceType {

    var syncCategoriesReturnValue: Observable<Void> = .just(())
    func syncCategories() -> Observable<Void> {
        return syncCategoriesReturnValue
    }

    var retrieveCategoriesReturnValue: Observable<[FactCategory]> = .just([])
    func retrieveCategories() -> Observable<[FactCategory]> {
        return retrieveCategoriesReturnValue
    }

    var searchFactsReturnValue: Observable<Void> = .just(())
    func searchFacts(searchTerm: String) -> Observable<Void> {
        return searchFactsReturnValue
    }

    var retrieveFactsReturnValue: Observable<[Fact]> = .just([])
    func retrieveFacts(searchTerm: String) -> Observable<[Fact]> {
        return retrieveFactsReturnValue
    }

    var retrievePastSearchesReturnValue: Observable<[String]> = .just([])
    func retrievePastSearches() -> Observable<[String]> {
        return retrievePastSearchesReturnValue
    }
}
