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
    case getCategories
}

extension FactsAPI: TargetType {

    var baseURL: URL {
        return URL(string: "https://api.chucknorris.io/jokes")!
    }

    var path: String {
        switch self {
        case .searchFacts:
            return "/search"
        case .getCategories:
            return "/categories"
        }
    }

    var method: Method {
        switch self {
        case .searchFacts, .getCategories:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .searchFacts(let searchTerm):
            return .requestParameters(parameters: ["query": searchTerm], encoding: URLEncoding.queryString)
        case .getCategories:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }

    var sampleData: Data {
        switch self {
        case .getCategories:
            return Data.stub("get-categories") ?? Data()
        case .searchFacts:
            return Data.stub("search-facts") ?? Data()
        }
    }

}
