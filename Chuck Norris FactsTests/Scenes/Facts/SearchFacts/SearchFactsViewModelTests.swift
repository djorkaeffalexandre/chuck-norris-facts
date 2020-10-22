//
//  SearchFactsViewModelTests.swift
//  Chuck Norris FactsTests
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/20/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import RxTest

@testable import Chuck_Norris_Facts

class SearchFactsViewModelTests: XCTestCase {

    var searchFactsViewModel: SearchFactsViewModel!
    var factsServiceMock: FactsServiceMock!
    var testScheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        disposeBag = DisposeBag()
        testScheduler = TestScheduler(initialClock: 0)
        searchFactsViewModel = SearchFactsViewModel()
        factsServiceMock = FactsServiceMock()
    }

    override func tearDown() {
        disposeBag = nil
        testScheduler = nil
        searchFactsViewModel = nil
        factsServiceMock = nil
    }

    func test_searchFactsWhenSearchShouldSearchFacts() {
        let searchFactsObserver = testScheduler.createObserver(String.self)

        searchFactsViewModel.didSearchFacts
            .subscribe(searchFactsObserver)
            .disposed(by: disposeBag)

        searchFactsViewModel.searchTerm.onNext("games")
        searchFactsViewModel.searchAction.onNext(())

        testScheduler.start()

        let searchFactsTerm = searchFactsObserver.events.compactMap { $0.value.element }.first
        XCTAssertEqual(searchFactsTerm, "games")
    }

    func test_cancelSearchShouldCallCancelSearch() {
        let cancelObserver = testScheduler.createObserver(Void.self)

        searchFactsViewModel.didCancel
            .subscribe(cancelObserver)
            .disposed(by: disposeBag)

        searchFactsViewModel.cancel.onNext(())

        testScheduler.start()

        let cancelCount = cancelObserver.events.compactMap { $0.value.element }.count
        XCTAssertEqual(cancelCount, 1)
    }

    func test_shouldLoad8RandomFactCategories() throws {
        let factCategoriesObserver = testScheduler.createObserver([FactCategoriesSectionModel].self)

        let testCategories = try stub("get-categories", type: [FactCategory].self) ?? []
        factsServiceMock.retrieveCategoriesReturnValue = .just(testCategories)

        searchFactsViewModel.categories
            .subscribe(factCategoriesObserver)
            .disposed(by: disposeBag)

        searchFactsViewModel.viewWillAppear.onNext(())

        testScheduler.start()

        let factCategoriesViewModel = factCategoriesObserver.events.compactMap { $0.value.element }.first
        XCTAssertEqual(factCategoriesViewModel?.first?.items.count, 8)
    }
}
