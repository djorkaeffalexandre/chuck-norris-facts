//
//  URLRequest+Encoded.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/30/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation

extension URLRequest {

    // Encode an URL request into a new URLRequest with parameters
    func encoded(parameters: [String: Any]?) -> URLRequest {
        guard let url = url else { return self }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.query = parameters?
            .compactMap { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        return URLRequest(url: components?.url ?? url)
    }
}
