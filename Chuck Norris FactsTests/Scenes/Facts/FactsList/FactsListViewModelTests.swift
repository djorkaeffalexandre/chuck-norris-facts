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

    func test_load10RandomFacts() throws {
        let factsListStub = try stub("facts-list", type: [Fact].self)
        let factsList = try XCTUnwrap(factsListStub, "looks like facts-list.json doesn't exists")
        factsServiceMock.searchFactsReturnValue = .just(factsList)

        let factsObserver = testScheduler.createObserver([FactsSectionModel].self)

        factsListViewModel.facts
            .subscribe(factsObserver)
            .disposed(by: disposeBag)

        factsListViewModel.setSearchTerm.onNext("games")
        factsListViewModel.viewDidAppear.onNext(())

        testScheduler.start()

        let sectionModels = factsObserver.events.compactMap { $0.value.element }.first
        XCTAssertEqual(sectionModels?.first?.items.count, 10)
    }

    func test_showShareFact() throws {
        let factStub = try stub("short-fact", type: Fact.self)
        let fact = try XCTUnwrap(factStub, "looks like short-fact.json doesn't exists")

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

    func test_categoriesShouldSyncWhenViewDidAppear() throws {
        let stubCategories = try stub("get-categories", type: [FactCategory].self) ?? []
        let categories = try XCTUnwrap(stubCategories, "looks like get-categories.json doesn't exists")
        factsServiceMock.retrieveCategoriesReturnValue = .just(categories)

        let syncCategoriesObserver = testScheduler.createObserver(Void.self)

        factsListViewModel.syncCategories
            .subscribe(syncCategoriesObserver)
            .disposed(by: disposeBag)

        factsListViewModel.viewDidAppear.onNext(())

        testScheduler.start()

        XCTAssertEqual(syncCategoriesObserver.events.count, 1)
    }
}
