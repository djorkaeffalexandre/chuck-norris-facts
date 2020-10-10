//
//  FactsListCoordinator.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/10/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit
import RxSwift

final class FactsListCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> Observable<Void> {
        let factsListViewModel = FactsListViewModel()
        let factsListViewController = FactsListViewController()
        factsListViewController.viewModel = factsListViewModel

        let navigationController = UINavigationController(rootViewController: factsListViewController)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        return Observable.never()
    }
}
