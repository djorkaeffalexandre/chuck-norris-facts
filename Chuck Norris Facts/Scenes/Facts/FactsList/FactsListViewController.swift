//
//  FactsListViewController.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/10/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Lottie

class FactsListViewController: UIViewController {

    var viewModel: FactsListViewModel!

    private let disposeBag = DisposeBag()

    let tableView = UITableView()
    let errorView = ErrorView()
    let loadingView = LoadingView()
    let emptyListView = EmptyListView()
    let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)

    private lazy var factsDataSource = RxTableViewSectionedAnimatedDataSource<FactsSectionModel>(
        configureCell: { [weak self] _, tableView, indexPath, fact -> UITableViewCell in

            guard let viewModel = self?.viewModel, let disposeBag = self?.disposeBag else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: FactCell.cellIdentifier, for: indexPath)

            if let cell = cell as? FactCell {
                cell.setup(fact)
                cell.shareButton.rx.tap
                    .map { fact }
                    .bind(to: viewModel.startShareFact)
                    .disposed(by: disposeBag)
            }

            return cell
        }
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupBindings()
        setupTableView()
        setupErrorView()
        setupEmptyListView()
        setupLoadingView()
        setupNavigationBar()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
    }

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.separatorStyle = .none

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        tableView.register(FactCell.self, forCellReuseIdentifier: FactCell.cellIdentifier)

        tableView.accessibilityIdentifier = "factsTableView"
    }

    private func setupLoadingView() {
        view.addSubview(loadingView)

        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func setupErrorView() {
        view.addSubview(errorView)

        errorView.isHidden = true
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func setupEmptyListView() {
        view.addSubview(emptyListView)

        emptyListView.translatesAutoresizingMaskIntoConstraints = false
        emptyListView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        emptyListView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        emptyListView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        emptyListView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func setupNavigationBar() {
        navigationItem.title = "Chuck Norris Facts"
        navigationItem.rightBarButtonItem = searchButton
        navigationController?.navigationBar.prefersLargeTitles = true

        searchButton.accessibilityIdentifier = "searchButton"
    }

    private func setupBindings() {
        rx.viewDidAppear
            .bind(to: viewModel.viewDidAppear)
            .disposed(by: disposeBag)

        viewModel.isLoading
            .drive(onNext: { [weak self] isLoading in
                self?.showLoadingView(isLoading)
            })
            .disposed(by: disposeBag)

        let factsIsEmpty = viewModel.facts
            .map { $0.flatMap { $0.items } }
            .map { $0.isEmpty }
            .share()

        let searchIsEmpty = viewModel.searchTerm
            .map { $0.isEmpty }
            .share()

        Observable.combineLatest(factsIsEmpty, searchIsEmpty)
            .asDriver(onErrorJustReturn: (true, true))
            .drive(onNext: { [weak self] listEmpty, searchEmpty in
                self?.showEmptyView(listEmpty, searchEmpty)
            })
            .disposed(by: disposeBag)

        viewModel.facts
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: factsDataSource))
            .disposed(by: disposeBag)

        searchButton.rx.tap
            .bind(to: viewModel.startSearchFacts)
            .disposed(by: disposeBag)

        emptyListView.searchButton.rx.tap
            .bind(to: viewModel.startSearchFacts)
            .disposed(by: disposeBag)

        errorView.retryButton.rx.tap
            .bind(to: viewModel.retryError)
            .disposed(by: disposeBag)

        viewModel.errors
            .bind(onNext: { [weak self] error in
                self?.showErrorView(error)
            })
            .disposed(by: disposeBag)
    }

    private func showEmptyView(_ listEmpty: Bool, _ searchEmpty: Bool) {
        tableView.isHidden = listEmpty
        emptyListView.isHidden = !listEmpty

        if searchEmpty {
            emptyListView.label.text = "Looks like there are no facts"
            emptyListView.searchButton.isHidden = false
        } else {
            emptyListView.label.text = "There are no facts to your search"
            emptyListView.searchButton.isHidden = true
        }

        if listEmpty {
            emptyListView.play()
        } else {
            emptyListView.stop()
        }
    }

    private func showLoadingView(_ isLoading: Bool) {
        tableView.isHidden = isLoading
        loadingView.isHidden = !isLoading

        if isLoading {
            loadingView.play()
        } else {
            loadingView.stop()
        }
    }

    private func showErrorView(_ error: FactsListError) {
        errorView.label.text = error.message
        errorView.retryButton.isHidden = !error.retry
        errorView.isHidden = false
        errorView.play()
    }
}
