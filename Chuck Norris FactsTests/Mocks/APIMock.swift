//
//  APIMock.swift
//  Chuck Norris FactsTests
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/30/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation

@testable import Chuck_Norris_Facts

final class APIMock: APIProvider<FactsAPI> {

    var requestReturnValue: Result<APIResponse, APIError>? = .success(APIResponse(statusCode: 200, data: Data()))

    override func request(
        _ target: FactsAPI,
        completion: @escaping APIProvider<FactsAPI>.Completion
    ) -> URLSessionDataTask? {
        completion(requestReturnValue ?? .failure(.unknown(nil)))
        return nil
    }

    func mockRequest(statusCode: Int, data: Data?) {
        requestReturnValue = .success(APIResponse(statusCode: statusCode, data: data))
    }
}
