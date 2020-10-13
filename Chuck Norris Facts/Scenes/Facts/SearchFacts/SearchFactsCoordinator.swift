//
//  SearchFactsCoordinator.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/13/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit
import RxSwift

enum SearchFactsCoordinationResult {
    case cancel
}

class SearchFactsCoordinator: BaseCoordinator<SearchFactsCoordinationResult> {

    private let rootViewController: UIViewController

    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    override func start() -> Observable<CoordinationResult> {
        let viewController = SearchFactsViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        let viewModel = SearchFactsViewModel()
        viewController.viewModel = viewModel

        let cancel = viewModel.didCancel.map { _ in CoordinationResult.cancel }

        rootViewController.present(navigationController, animated: true)

        return cancel
            .take(1)
            .do(onNext: { [weak self] _ in self?.rootViewController.dismiss(animated: true) })
    }
}
