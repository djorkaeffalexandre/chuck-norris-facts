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

    // Completion of a request make by a provider.
    typealias Completion = (_ result: Result<APIResponse, APIError>) -> Void

    // Associated type of an APITarget.
    associatedtype Target: APITarget

    // Designated request-making method.
    func request(_ target: Target, completion: @escaping Completion) -> URLSessionDataTask?
}

class APIProvider<Target: APITarget>: APIProviderType {

    // Closure that defines the urlRequest for the provider.
    typealias RequestClosure = (Target) -> URLRequest

    // A closure responsible for mapping a `APITarget` to an `URLRequest`.
    let requestClosure: RequestClosure

    private let urlSession: URLSession

    init(
        urlSession: URLSession = URLSession.shared,
        requestClosure: @escaping RequestClosure = { $0.urlRequest() }
    ) {
        self.urlSession = urlSession
        self.requestClosure = requestClosure
    }

    // Designated request-making method.
    func request(_ target: Target, completion: @escaping Completion) -> URLSessionDataTask? {

        let request = requestClosure(target)

        if let sampleData = target.sampleData {
            completion(.success(APIResponse(statusCode: 200, data: sampleData)))
            return nil
        }

        let task = urlSession.dataTask(with: request) { (data, response, error) in
            let response = response as? HTTPURLResponse

            let result = self.convertResponseToResult(
                response,
                request: request,
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
