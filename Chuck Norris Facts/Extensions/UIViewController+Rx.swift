//
//  UIViewController+Rx.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/12/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit
import RxSwift

extension Reactive where Base: UIViewController {
    var viewDidAppear: Observable<Void> {
        sentMessage(#selector(Base.viewDidAppear(_:))).map { _ in () }
    }

    var viewWillAppear: Observable<Void> {
        sentMessage(#selector(Base.viewWillAppear(_:))).map { _ in () }
    }
}
