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

    var searchFactsReturnValue: Observable<[Fact]> = .just([])
    func searchFacts(query: String) -> Observable<[Fact]> {
        return searchFactsReturnValue
    }
}
