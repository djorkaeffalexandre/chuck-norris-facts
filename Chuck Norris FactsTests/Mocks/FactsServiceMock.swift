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

    var searchFactsReturnValue: Observable<[Fact]> = .just([])
    func searchFacts(searchTerm: String) -> Observable<[Fact]> {
        return searchFactsReturnValue
    }

    var retrievePastSearchesReturnValue: Observable<[String]> = .just([])
    func retrievePastSearches() -> Observable<[String]> {
        return retrievePastSearchesReturnValue
    }
}
