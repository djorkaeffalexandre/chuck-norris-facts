//
//  MoyaError+Code.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/28/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Moya
import Alamofire

enum HTTPErrorCode: Int {
    case unknown = 0
    case noConnection = 1
}

extension MoyaError {

    var code: HTTPErrorCode {
        let alamofireError = errorUserInfo["NSUnderlyingError"] as? Alamofire.AFError
        let error = alamofireError?.underlyingError as NSError?

        switch error?.code {
        case NSURLErrorNotConnectedToInternet:
            return .noConnection
        default:
            return .unknown
        }
    }
}
