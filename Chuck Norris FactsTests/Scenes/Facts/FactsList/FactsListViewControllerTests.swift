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

    func test_FactsListViewController_WhenFactsIsEmpty_WhenSearchTermIsEmpty_ShouldShowEmptyList() {
        factsServiceMock.searchFactsReturnValue = .just([])

        factsListViewModel.inputs.viewDidAppear.onNext(())

        XCTAssertFalse(factsListViewController.emptyListView.isHidden)
        XCTAssertEqual(factsListViewController.emptyListView.label.text, L10n.EmptyView.empty)
        XCTAssertFalse(factsListViewController.emptyListView.searchButton.isHidden)
    }

    func test_FactsListViewController_WhenFactsIsEmpty_WhenSearchTermIsNotEmpty_ShouldShowEmptyList() {
        factsServiceMock.searchFactsReturnValue = .just([])

        factsListViewModel.inputs.setSearchTerm.onNext("games")
        factsListViewModel.inputs.viewDidAppear.onNext(())

        XCTAssertFalse(factsListViewController.emptyListView.isHidden)
        XCTAssertEqual(factsListViewController.emptyListView.label.text, L10n.EmptyView.emptySearch)
        XCTAssertTrue(factsListViewController.emptyListView.searchButton.isHidden)
    }

    func test_FactsListViewController_WhenThereIsAnError_ShouldShowErrorView() {
        let response = APIResponse(statusCode: 500, data: nil)
        let apiError = APIError.statusCode(response)
        factsServiceMock.searchFactsReturnValue = .error(apiError)

        factsListViewModel.inputs.setSearchTerm.onNext("")

        XCTAssertFalse(factsListViewController.errorView.isHidden)
    }

    func test_FactCell_WhenContentIsShort_FontSizeShouldBeTitle1() throws {
        let factStub = try stub("short-fact", type: Fact.self)
        let fact = try XCTUnwrap(factStub)

        factsServiceMock.searchFactsReturnValue = .just([fact])

        factsListViewModel.inputs.setSearchTerm.onNext("")

        let factCell = factsListFirstCell()

        XCTAssertEqual(factCell?.bodyLabel.font, .preferredFont(forTextStyle: .title1))
    }

    func test_FactCell_WhenContentIsLong_FontSizeShouldBeTitle3() throws {
        let factStub = try stub("long-fact", type: Fact.self)
        let fact = try XCTUnwrap(factStub)

        factsServiceMock.searchFactsReturnValue = .just([fact])

        factsListViewModel.inputs.setSearchTerm.onNext("")

        let factCell = factsListFirstCell()

        XCTAssertEqual(factCell?.bodyLabel.font, .preferredFont(forTextStyle: .title3))
    }

    func test_FactCell_WhenTapShareFact_ShouldShowShareActivity() throws {
        let factStub = try stub("short-fact", type: Fact.self)
        let fact = try XCTUnwrap(factStub)

        factsServiceMock.searchFactsReturnValue = .just([fact])

        let testScheduler = TestScheduler(initialClock: 0)
        let shareFactObserver = testScheduler.createObserver(FactViewModel.self)

        factsListViewModel.inputs.setSearchTerm.onNext("games")
        factsListViewModel.inputs.viewDidAppear.onNext(())

        factsListViewModel.outputs.showShareFact
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
