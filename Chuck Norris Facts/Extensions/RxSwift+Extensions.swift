//
//  RxSwift+Extensions.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 11/1/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        map { _ in () }
    }
}

extension ObservableType where Element: EventConvertible {
    func elements() -> Observable<Element.Element> {
        compactMap { $0.event.element }
    }

    func errors() -> Observable<Swift.Error> {
        compactMap { $0.event.error }
    }
}
