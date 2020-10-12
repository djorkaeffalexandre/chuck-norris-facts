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

class FactsListViewController: UIViewController {

    var viewModel: FactsListViewModel!

    private let disposeBag = DisposeBag()

    let tableView = UITableView()
    let emptyListView = EmptyListView()

    private lazy var factsDataSource = RxTableViewSectionedAnimatedDataSource<FactsSectionModel>(
        configureCell: { [weak self] _, tableView, indexPath, fact -> UITableViewCell in

            guard let viewModel = self?.viewModel, let disposeBag = self?.disposeBag else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: FactTableViewCell.cellIdentifier, for: indexPath)

            if let cell = cell as? FactTableViewCell {
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
        setupEmptyListView()
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

        tableView.register(FactTableViewCell.self, forCellReuseIdentifier: FactTableViewCell.cellIdentifier)

        tableView.accessibilityIdentifier = "factsTableView"
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
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupBindings() {
        rx.viewDidAppear
            .bind(to: viewModel.viewDidAppear)
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
}
