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

    private lazy var collectionView: UICollectionView = {
        let layout = FactCategoryViewFlowLayout()

        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        return UICollectionView(frame: .zero, collectionViewLayout: layout)
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
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        view.accessibilityIdentifier = "searchFactsView"
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)

        collectionView.backgroundColor = .systemBackground

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        collectionView.register(FactCategoryCell.self, forCellWithReuseIdentifier: FactCategoryCell.cellIdentifier)
    }

    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Search"
    }

    private func setupBindings() {
        rx.viewWillAppear
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)

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
    }
}
