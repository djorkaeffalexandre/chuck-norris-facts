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

    let tableView = UITableView()

    private lazy var categoriesDataSource = RxTableViewSectionedAnimatedDataSource<FactCategoriesSectionModel>(
        configureCell: { [weak self] _, tableView, indexPath, category -> UITableViewCell in

            guard let viewModel = self?.viewModel, let disposeBag = self?.disposeBag else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)

            cell.textLabel?.text = category.text

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
        setupTableView()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        view.accessibilityIdentifier = "searchFactsView"
    }

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.separatorStyle = .none

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
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
            .bind(to: tableView.rx.items(dataSource: categoriesDataSource))
            .disposed(by: disposeBag)

        let categorySelected = tableView.rx
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
