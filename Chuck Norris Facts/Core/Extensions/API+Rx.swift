//
//  API+Rx.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/30/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation
import RxSwift

extension APIProvider: ReactiveCompatible {}

extension Reactive where Base: APIProviderType {

    func request(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<APIResponse> {
        return Single.create { [weak base] single in
            let cancellableToken = base?.request(token) { result in
                switch result {
                case let .success(response):
                    single(.success(response))
                case let .failure(error):
                    single(.error(error))
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
}

extension ObservableType where Element == APIResponse {
    func map<D: Decodable>(_ type: D.Type, using decoder: JSONDecoder = JSON.decoder) -> Observable<D> {
        flatMap { response -> Observable<D> in
            do {
                guard let data = response.data else {
                    throw APIError.dataMapping(nil)
                }

                return Observable.just(try decoder.decode(D.self, from: data))
            } catch let error {
                throw APIError.objectMapping(error, response)
            }
        }
    }
}
