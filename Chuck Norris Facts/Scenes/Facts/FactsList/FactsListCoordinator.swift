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

        factsListViewModel.showShareFact
            .bind(onNext: { [weak self] in
                self?.showShareFact(fact: $0, in: navigationController)
            })
            .disposed(by: disposeBag)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        return Observable.never()
    }

    private func showShareFact(fact: FactViewModel, in navigationController: UINavigationController) {
        var activityItems: [Any] = [fact.text]

        if let factUrl = fact.url {
            activityItems.append(factUrl)
        }

        let shareActivity = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        navigationController.present(shareActivity, animated: true, completion: nil)
    }
}
