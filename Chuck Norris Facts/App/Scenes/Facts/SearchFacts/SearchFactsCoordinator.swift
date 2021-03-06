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
    case search(String)
}

final class SearchFactsCoordinator: BaseCoordinator<SearchFactsCoordinationResult> {

    private let rootViewController: UIViewController

    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    override func start() -> Observable<CoordinationResult> {
        let searchFactsViewController = SearchFactsViewController()
        let navigationController = UINavigationController(rootViewController: searchFactsViewController)

        let searchFactsViewModel = SearchFactsViewModel()
        searchFactsViewController.viewModel = searchFactsViewModel

        let cancelSearchFacts = searchFactsViewModel.outputs.didCancel.map { _ in CoordinationResult.cancel }
        let selectSearchTerm = searchFactsViewModel.outputs.didSelectItem.map { CoordinationResult.search($0) }
        let searchFacts = searchFactsViewModel.outputs.didSearchFacts.map { CoordinationResult.search($0) }

        rootViewController.present(navigationController, animated: true)

        return Observable.merge(cancelSearchFacts, selectSearchTerm, searchFacts)
            .take(1)
            .do(onNext: { [weak self] _ in self?.rootViewController.dismiss(animated: true) })
    }
}
