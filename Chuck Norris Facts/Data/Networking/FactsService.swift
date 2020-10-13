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
    let facts: [Fact]

    enum CodingKeys: String, CodingKey {
        case total
        case facts = "result"
    }
}

protocol FactsServiceType {
    func searchFacts(query: String) -> Observable<[Fact]>
}

final class FactsService: FactsServiceType {

    func searchFacts(query: String) -> Observable<[Fact]> {
        if CommandLine.arguments.contains("--empty-facts") {
            return .just([])
        }

        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: "https://api.chucknorris.io/jokes/search?query=\(encodedQuery)")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        return Observable<[Fact]>.create { observer in
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    if let data = data {
                        let response = try JSON.decoder.decode(SearchFactsResponse.self, from: data)
                        observer.onNext(response.facts)
                    }
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
