//
//  FactsService.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/10/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Moya

enum FactsAPI {
    case searchFacts(searchTerm: String)
}

extension FactsAPI: TargetType {

    var baseURL: URL {
        return URL(string: "https://api.chucknorris.io/jokes")!
    }

    var path: String {
        switch self {
        case .searchFacts:
            return "/search"
        }
    }

    var method: Method {
        switch self {
        case .searchFacts:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .searchFacts(let searchTerm):
            return .requestParameters(parameters: ["query": searchTerm], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }

    var sampleData: Data {
        return Data()
    }

}
