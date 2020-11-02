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

        // Check if request has some sampleData
        if let sampleData = target.sampleData {
            completion(.success(APIResponse(statusCode: 200, data: sampleData)))
            return nil
        }

        let task = urlSession.dataTask(with: request) { (data, response, error) in
            // Check if error is not connected to internet
            if let error = error as NSError?, error.code == NSURLErrorNotConnectedToInternet {
                completion(.failure(.noConnection))
                return
            }

            // Check if there is an error
            if let error = error {
                completion(.failure(.unknown(error)))
                return
            }

            // Check if response is a HTTPURLResponse
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.connectionError))
                return
            }

            // Complete with an APIResponse
            completion(.success(APIResponse(statusCode: response.statusCode, data: data)))
        }

        task.resume()

        return task
    }
}
