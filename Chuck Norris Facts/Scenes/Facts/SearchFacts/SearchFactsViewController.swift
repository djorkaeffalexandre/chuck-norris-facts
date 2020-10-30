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
        configureCell: { dataSource, tableView, indexPath, _ -> UITableViewCell in

            switch dataSource[indexPath] {
            case .SuggestionsTableViewItem(let suggestions):
                let cell = SuggestionsCell(style: .default, reuseIdentifier: SuggestionsCell.identifier)
                let viewModel = SuggestionsViewModel(suggestions: suggestions)
                cell.viewModel = viewModel
                viewModel.didSelectSuggestion
                    .bind(to: self.viewModel.searchTerm)
                    .disposed(by: self.disposeBag)
                viewModel.didSelectSuggestion
                    .map { _ in () }
                    .bind(to: self.viewModel.searchAction)
                    .disposed(by: self.disposeBag)
                return cell
            case .PastSearchTableViewItem(let model):
                let cell = tableView.dequeueReusableCell(withIdentifier: PastSearchCell.identifier) as? PastSearchCell
                    ?? PastSearchCell(style: .default, reuseIdentifier: PastSearchCell.identifier)
                cell.setup(model)
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

        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        tableView.register(SuggestionsCell.self, forCellReuseIdentifier: SuggestionsCell.identifier)
        tableView.register(PastSearchCell.self, forCellReuseIdentifier: PastSearchCell.identifier)
    }

    private func setupNavigationBar() {
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = L10n.SearchFacts.title
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

        viewModel.items
            .bind(to: tableView.rx.items(dataSource: itemsDataSource))
            .disposed(by: disposeBag)

        let pastSearchSelected = tableView.rx
            .modelSelected(SearchFactsTableViewItem.self)
            .asObservable()

        pastSearchSelected
            .compactMap {
                switch $0 {
                case .PastSearchTableViewItem(let model):
                    return model.text
                default:
                    break
                }
                return ""
            }
            .filter { !$0.isEmpty }
            .bind(to: viewModel.searchTerm)
            .disposed(by: disposeBag)

        pastSearchSelected
            .map { _ in () }
            .bind(to: viewModel.searchAction)
            .disposed(by: disposeBag)
    }
}
