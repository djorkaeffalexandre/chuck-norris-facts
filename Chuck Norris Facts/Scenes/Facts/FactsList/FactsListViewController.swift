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

class FactsListViewController: UIViewController {

    var viewModel: FactsListViewModel!

    private let disposeBag = DisposeBag()
    private let tableView = UITableView()
    private let emptyView = EmptyView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupBindings()
        setupTableView()
        setupEmptyView()
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
    }

    private func setupEmptyView() {
        view.addSubview(emptyView)

        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func setupNavigationBar() {
        navigationItem.title = "Chuck Norris Facts"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupBindings() {
        viewModel.facts
            .map { $0.isEmpty }
            .share()
            .asDriver(onErrorJustReturn: true)
            .drive(onNext: { [weak self] isEmpty in
                self?.showEmptyView(isEmpty)
            })
            .disposed(by: disposeBag)

        viewModel.facts
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: FactTableViewCell.cellIdentifier, cellType: FactTableViewCell.self)) { _, fact, cell in
                cell.setup(fact)
                cell.shareButton.rx.tap
                    .map { fact }
                    .bind(to: self.viewModel.startShareFact)
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
    }

    private func showEmptyView(_ isEmpty: Bool) {
        tableView.isHidden = isEmpty
        emptyView.isHidden = !isEmpty

        if isEmpty {
            emptyView.play()
        } else {
            emptyView.stop()
        }
    }
}
