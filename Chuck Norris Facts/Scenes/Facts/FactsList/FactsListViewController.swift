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

    private lazy var loadingView: AnimationView = {
        let loading = AnimationView()

        loading.backgroundColor = .systemBackground
        loading.animation = Animation.named("loading")
        loading.loopMode = .loop

        return loading
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupBindings()
        setupTableView()
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

        viewModel.facts
            .map { $0.flatMap { $0.items } }
            .map { $0.isEmpty }
            .asDriver(onErrorJustReturn: true)
            .drive(onNext: { [weak self] isEmpty in
                self?.showEmptyView(isEmpty)
            })
            .disposed(by: disposeBag)

        viewModel.facts
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: factsDataSource))
            .disposed(by: disposeBag)

        searchButton.rx.tap
            .bind(to: viewModel.startSearchFacts)
            .disposed(by: disposeBag)

        viewModel.syncCategories
            .asDriver(onErrorJustReturn: ())
            .drive()
            .disposed(by: disposeBag)
    }

    private func showEmptyView(_ isEmpty: Bool) {
        tableView.isHidden = isEmpty
        emptyListView.isHidden = !isEmpty

        if isEmpty {
            emptyListView.play()
        } else {
            emptyListView.stop()
        }
    }

    private func showLoadingView(_ isLoading: Bool) {
        tableView.isHidden = isLoading
        loadingView.isHidden = !isLoading

        if isLoading {
            emptyListView.isHidden = isLoading
            loadingView.play()
        } else {
            loadingView.stop()
        }
    }
}
