//
//  FactsService.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/20/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import RxSwift
import Moya

protocol FactsServiceType {
    func searchFacts(searchTerm: String) -> Observable<[Fact]>
}

struct FactsService: FactsServiceType {

    private let provider = MoyaProvider<FactsAPI>()

    func searchFacts(searchTerm: String) -> Observable<[Fact]> {
        provider.rx
            .request(.searchFacts(searchTerm: searchTerm))
            .asObservable()
            .map(SearchFactsResponse.self, using: JSON.decoder)
            .map { $0.facts }
    }

}
