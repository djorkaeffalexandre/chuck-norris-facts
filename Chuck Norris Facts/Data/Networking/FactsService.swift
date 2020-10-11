//
//  FactsService.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/10/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation
import RxSwift

struct SearchFactsResponse: Decodable {
    let total: Int
    let result: [Fact]
}

protocol FactsServiceType {
    func searchFacts(query: String) -> Observable<[Fact]>
}

final class FactsService: FactsServiceType {

    func searchFacts(query: String) -> Observable<[Fact]> {
        return Observable<[Fact]>.create { observer in
            do {
                guard let file = Bundle.main.url(forResource: "search-facts", withExtension: ".json") else {
                    return Disposables.create {}
                }

                let data = try Data(contentsOf: file)
                let searchFactsResponse = try JSON.decoder.decode(SearchFactsResponse.self, from: data)
                observer.onNext(searchFactsResponse.result)
            } catch {
                observer.onError(error)
            }
            observer.onCompleted()

            return Disposables.create {}
        }
    }
}
