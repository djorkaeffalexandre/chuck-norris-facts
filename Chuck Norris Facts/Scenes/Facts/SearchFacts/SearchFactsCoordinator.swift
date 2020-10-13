//
//  SearchFactsCoordinator.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/13/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit
import RxSwift

final class SearchFactsCoordinator: BaseCoordinator<Void> {

    private let rootViewController: UIViewController

    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    override func start() -> Observable<Void> {
        let searchFactsViewController = SearchFactsViewController()
        let navigationController = UINavigationController(rootViewController: searchFactsViewController)

        rootViewController.present(navigationController, animated: true)

        return Observable.never()
    }
}
