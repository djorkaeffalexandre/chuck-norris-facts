//
//  SearchFactsViewController.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/13/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit
import RxSwift

final class SearchFactsViewController: UIViewController {

    var viewModel: SearchFactsViewModel!

    let disposeBag = DisposeBag()

    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)

    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)

        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.searchBar.returnKeyType = .search

        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupNavigationBar()
        setupBindings()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
    }

    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Search"
    }

    private func setupBindings() {
        cancelButton.rx.tap
            .bind(to: viewModel.cancel)
            .disposed(by: disposeBag)
    }
}
