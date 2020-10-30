//
//  APIProvider.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/30/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation

// A protocol representing a minimal interface for a APIProvider.
protocol APIProviderType: AnyObject {

    typealias Completion = (_ result: Result<APIResponse, APIError>) -> Void

    associatedtype Target: APITarget

    // Designated request-making method.
    func request(_ target: Target, completion: @escaping Completion) -> URLSessionDataTask?
}

class APIProvider<Target: APITarget>: APIProviderType {

    // Designated request-making method.
    func request(_ target: Target, completion: @escaping Completion) -> URLSessionDataTask? {
        let targetRequest = target.urlRequest()

        let task = URLSession.shared.dataTask(with: targetRequest) { (data, response, error) in
            let result = self.convertResponseToResult(
                response as? HTTPURLResponse,
                request: targetRequest,
                data: data,
                error: error
            )
            completion(result)
        }

        task.resume()

        return task
    }

    // A function responsible for converting the result of a `URLRequest` to a Result<APIResponse, APIError>.
    private func convertResponseToResult(
        _ response: HTTPURLResponse?,
        request: URLRequest?,
        data: Data?,
        error: Swift.Error?
    ) -> Result<APIResponse, APIError> {
            switch (response, data, error) {
            case let (.some(response), data, .none):
                let response = APIResponse(statusCode: response.statusCode, data: data ?? Data())
                return .success(response)
            case let (.some(response), _, .some(error)):
                let response = APIResponse(statusCode: response.statusCode, data: data ?? Data())
                let error = APIError.underlying(error, response)
                return .failure(error)
            case let (_, _, .some(error)):
                let error = APIError.underlying(error, nil)
                return .failure(error)
            default:
                let error = APIError.underlying(
                    NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil),
                    nil
                )
                return .failure(error)
            }
    }
}
