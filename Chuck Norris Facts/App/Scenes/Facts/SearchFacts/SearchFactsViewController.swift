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

    private lazy var itemsDataSource = RxTableViewSectionedReloadDataSource<SearchFactsTableViewSection>(
        configureCell: { [weak self] dataSource, tableView, indexPath, _ -> UITableViewCell in

            switch dataSource[indexPath] {
            case .SuggestionsTableViewItem(let suggestions):
                guard let searchFactsViewModel = self?.viewModel else { return UITableViewCell() }

                let cell = tableView.dequeueReusableCell(cell: SuggestionsCell.self, indexPath: indexPath)

                let viewModel = SuggestionsViewModel(suggestions: suggestions)
                cell.viewModel = viewModel

                viewModel.outputs.didSelectSuggestion
                    .bind(to: searchFactsViewModel.inputs.selectItem)
                    .disposed(by: cell.disposeBag)

                return cell
            case .PastSearchTableViewItem(let pastSearch):
                let cell = tableView.dequeueReusableCell(cell: PastSearchCell.self, indexPath: indexPath)
                cell.setup(pastSearch)
                return cell
            }

        }, titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].header
        }
    )

    lazy var tableView: UITableView = {
        let tableView = UITableView()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.accessibilityIdentifier = "itemsTableView"
        tableView.tableFooterView = UIView()

        return tableView
    }()

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

        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = UITableView.automaticDimension

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.register(SuggestionsCell.self)
        tableView.register(PastSearchCell.self)
    }

    private func setupNavigationBar() {
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = L10n.SearchFacts.title
    }

    private func setupBindings() {
        rx.viewWillAppear
            .bind(to: viewModel.inputs.viewWillAppear)
            .disposed(by: disposeBag)

        cancelButton.rx.tap
            .bind(to: viewModel.inputs.cancel)
            .disposed(by: disposeBag)

        searchController.searchBar.rx.text
            .compactMap { $0 }
            .bind(to: viewModel.inputs.searchTerm)
            .disposed(by: disposeBag)

        searchController.searchBar.rx.textDidEndEditing
            .bind(to: viewModel.inputs.searchAction)
            .disposed(by: disposeBag)

        viewModel.outputs.items
            .bind(to: tableView.rx.items(dataSource: itemsDataSource))
            .disposed(by: disposeBag)

        let pastSearchSelected = tableView.rx
            .modelSelected(SearchFactsTableViewItem.self)
            .asObservable()

        pastSearchSelected
            .compactMap { $0.text }
            .bind(to: viewModel.inputs.selectItem)
            .disposed(by: disposeBag)

        pastSearchSelected
            .mapToVoid()
            .bind(to: viewModel.inputs.searchAction)
            .disposed(by: disposeBag)
    }
}
