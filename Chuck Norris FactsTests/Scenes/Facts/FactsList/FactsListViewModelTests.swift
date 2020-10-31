//
//  FactsListViewModelTests.swift
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

class FactsListViewModelTests: XCTestCase {
    var factsListViewModel: FactsListViewModel!
    var factsServiceMock: FactsServiceMock!
    var testScheduler: TestScheduler!

    var disposeBag: DisposeBag!

    override func setUp() {
        disposeBag = DisposeBag()
        testScheduler = TestScheduler(initialClock: 0)
        factsServiceMock = FactsServiceMock()
        factsListViewModel = FactsListViewModel(factsService: factsServiceMock)
    }

    override func tearDown() {
        disposeBag = nil
        testScheduler = nil
        factsServiceMock = nil
        factsListViewModel = nil
    }

    func test_FactsListViewModel_WhenViewDidAppear_ShouldLoadEmptyFacts() throws {
        factsServiceMock.searchFactsReturnValue = .just([])

        let factsObserver = testScheduler.createObserver([FactsSectionModel].self)

        factsListViewModel.facts
            .subscribe(factsObserver)
            .disposed(by: disposeBag)

        factsListViewModel.viewDidAppear.onNext(())

        testScheduler.start()

        let sectionModels = factsObserver.events.compactMap { $0.value.element }.first
        XCTAssertEqual(sectionModels?.first?.items.count, 0)
    }

    func test_FactsListViewModel_WhenStartShareFact_ShouldShowShareFact() throws {
        let factStub = try stub("short-fact", type: Fact.self)
        let fact = try XCTUnwrap(factStub)

        factsListViewModel.viewDidAppear.onNext(())

        let factObserver = testScheduler.createObserver(FactViewModel.self)

        factsListViewModel.showShareFact
            .subscribe(factObserver)
            .disposed(by: disposeBag)

        let factViewModel = FactViewModel(fact: fact)
        factsListViewModel.startShareFact.onNext(factViewModel)

        let shareFact = factObserver.events.compactMap { $0.value.element }.first
        XCTAssertEqual(fact.value, shareFact?.text)
    }

    func test_FactsListViewModel_WhenViewDidAppear_ShouldSyncCategoriesWithNoErrors() throws {
        let stubCategories = try stub("get-categories", type: [FactCategory].self) ?? []
        let categories = try XCTUnwrap(stubCategories)
        factsServiceMock.retrieveCategoriesReturnValue = .just(categories)

        let errorObserver = testScheduler.createObserver(FactsListError.self)

        factsListViewModel.errors
            .subscribe(errorObserver)
            .disposed(by: disposeBag)

        factsListViewModel.viewDidAppear.onNext(())

        testScheduler.start()

        let error = errorObserver.events.compactMap { $0.value.element }.first
        XCTAssertNil(error)
    }

    func test_FactsListViewModel_WhenSearchFactsWithError_ShouldEmmitFactListError() throws {
        let response = APIResponse(statusCode: 500, data: nil)
        let apiError = APIError.statusCode(response)
        factsServiceMock.searchFactsReturnValue = .error(apiError)

        let errorObserver = testScheduler.createObserver(FactsListError.self)

        factsListViewModel.errors
            .subscribe(errorObserver)
            .disposed(by: disposeBag)

        factsListViewModel.viewDidAppear.onNext(())

        testScheduler.start()

        let error = errorObserver.events.compactMap { $0.value.element }.first
        XCTAssertEqual(error?.code, FactsListError.searchFacts(apiError).code)
    }
}
