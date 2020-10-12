//
//  FactsListViewControllerTests.swift
//  Chuck Norris FactsTests
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/11/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import RxTest

@testable import Chuck_Norris_Facts

class FactsListViewControllerTests: XCTestCase {

    var factsListViewController: FactsListViewController!
    var factsListViewModel: FactsListViewModel!
    var disposeBag: DisposeBag!

    override func setUp() {
        disposeBag = DisposeBag()
        factsListViewModel = FactsListViewModel()
        factsListViewController = FactsListViewController()
        factsListViewController.viewModel = factsListViewModel
    }

    override func tearDown() {
        disposeBag = nil
        factsListViewModel = nil
        factsListViewController = nil
    }

}

extension FactsListViewControllerTests {
    func factsListFirstCell() -> FactTableViewCell? {
        let indexPath = IndexPath(row: 0, section: 0)
        return factsListViewController.tableView.cellForRow(at: indexPath) as? FactTableViewCell
    }
}
