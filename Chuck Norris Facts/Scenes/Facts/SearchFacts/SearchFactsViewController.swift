//
//  SearchFactsViewController.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/13/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

final class SearchFactsViewController: UIViewController {

    var viewModel: SearchFactsViewModel!

    let disposeBag = DisposeBag()

    lazy var collectionView: UICollectionView = {
        let layout = FactCategoryViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()

        return tableView
    }()

    private lazy var categoriesDataSource = RxCollectionViewSectionedReloadDataSource<FactCategoriesSectionModel>(
        configureCell: { _, collectionView, indexPath, category -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FactCategoryCell.cellIdentifier,
                for: indexPath
            )
            if let cell = cell as? FactCategoryCell {
                cell.setup(category)
            }
            return cell
        }
    )

    private lazy var pastSearchesDataSource = RxTableViewSectionedReloadDataSource<PastSearchesSectionModel>(
        configureCell: { _, tableView, indexPath, pastSearch -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
            cell.textLabel?.text = pastSearch.text
            cell.imageView?.image = UIImage(systemName: "magnifyingglass")
            return cell
        },
        titleForHeaderInSection: { _, _ in
            "Past Searches"
        }
    )

    lazy var cancelButton: UIBarButtonItem = {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        cancelButton.accessibilityIdentifier = "cancelButton"
        return cancelButton
    }()

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
        setupCollectionView()
        setupTableView()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        view.accessibilityIdentifier = "searchFactsView"

        rx.viewWillAppear
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)

        collectionView.backgroundColor = .systemBackground

        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        collectionView.isScrollEnabled = false

        collectionView.register(FactCategoryCell.self, forCellWithReuseIdentifier: FactCategoryCell.cellIdentifier)

        collectionView.accessibilityIdentifier = "factCategoriesCollectionView"
    }

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.backgroundColor = .systemBackground

        tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
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

        searchController.searchBar.rx.text
            .compactMap { $0 }
            .bind(to: viewModel.searchTerm)
            .disposed(by: disposeBag)

        searchController.searchBar.rx.textDidEndEditing
            .bind(to: viewModel.searchAction)
            .disposed(by: disposeBag)

        viewModel.categories
            .observeOn(MainScheduler.instance)
            .bind(to: collectionView.rx.items(dataSource: categoriesDataSource))
            .disposed(by: disposeBag)

        viewModel.pastSearches
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: pastSearchesDataSource))
            .disposed(by: disposeBag)

        let categorySelected = collectionView.rx
            .modelSelected(FactCategoryViewModel.self)
            .asObservable()

        categorySelected
            .compactMap { $0.text }
            .bind(to: viewModel.searchTerm)
            .disposed(by: disposeBag)

        categorySelected
            .map { _ in () }
            .bind(to: viewModel.searchAction)
            .disposed(by: disposeBag)

        let pastSearchSelected = tableView.rx
            .modelSelected(PastSearchViewModel.self)
            .asObservable()

        pastSearchSelected
            .compactMap { $0.text }
            .bind(to: viewModel.searchTerm)
            .disposed(by: disposeBag)

        pastSearchSelected
            .map { _ in () }
            .bind(to: viewModel.searchAction)
            .disposed(by: disposeBag)
    }
}
