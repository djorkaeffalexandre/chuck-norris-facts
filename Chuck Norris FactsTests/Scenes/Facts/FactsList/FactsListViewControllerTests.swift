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
    var factsServiceMock: FactsServiceMock!
    var disposeBag: DisposeBag!

    override func setUp() {
        disposeBag = DisposeBag()
        factsServiceMock = FactsServiceMock()
        factsListViewModel = FactsListViewModel(factsService: factsServiceMock)
        factsListViewController = FactsListViewController()
        factsListViewController.viewModel = factsListViewModel

        factsListViewController.loadViewIfNeeded()
    }

    override func tearDown() {
        disposeBag = nil
        factsListViewModel = nil
        factsListViewController = nil
    }

    func test_factsListEmptyShouldShowEmptyList() {
        factsServiceMock.retrieveFactsReturnValue = .just([])

        factsListViewModel.viewDidAppear.onNext(())

        XCTAssertFalse(factsListViewController.emptyListView.isHidden)
        XCTAssertTrue(factsListViewController.tableView.isHidden)
    }

    func test_factCellFontSizeShouldBe24ForShortContent() throws {
        let factStub = try stub("short-fact", type: Fact.self)
        let fact = try XCTUnwrap(factStub, "looks like short-fact.json doesn't exists")

        factsServiceMock.retrieveFactsReturnValue = .just([fact])

        factsListViewModel.viewDidAppear.onNext(())

        let factCell = factsListFirstCell()

        XCTAssertEqual(factCell?.bodyLabel.font.pointSize, 24)
    }

    func test_factCellFontSizeShouldBe16ForLongContent() throws {
        let factStub = try stub("long-fact", type: Fact.self)
        let fact = try XCTUnwrap(factStub, "looks like long-fact.json doesn't exists")

        factsServiceMock.retrieveFactsReturnValue = .just([fact])

        factsListViewModel.viewDidAppear.onNext(())

        let factCell = factsListFirstCell()

        XCTAssertEqual(factCell?.bodyLabel.font.pointSize, 16)
    }

    func test_shareFactButtonTapShouldShowShareFact() throws {
        let factStub = try stub("short-fact", type: Fact.self)
        let fact = try XCTUnwrap(factStub, "looks like short-fact.json doesn't exists")

        factsServiceMock.retrieveFactsReturnValue = .just([fact])

        let testScheduler = TestScheduler(initialClock: 0)
        let shareFactObserver = testScheduler.createObserver(FactViewModel.self)

        factsListViewModel.setSearchTerm.onNext("games")
        factsListViewModel.viewDidAppear.onNext(())

        factsListViewModel.showShareFact
            .subscribe(shareFactObserver)
            .disposed(by: disposeBag)

        testScheduler.start()

        let factCell = factsListFirstCell()
        factCell?.shareButton.sendActions(for: .touchUpInside)

        let events = shareFactObserver.events.compactMap { $0.value.element }
        XCTAssertEqual(events.count, 1)
    }

}

extension FactsListViewControllerTests {
    func factsListFirstCell() -> FactCell? {
        let indexPath = IndexPath(row: 0, section: 0)
        return factsListViewController.tableView.cellForRow(at: indexPath) as? FactCell
    }
}
