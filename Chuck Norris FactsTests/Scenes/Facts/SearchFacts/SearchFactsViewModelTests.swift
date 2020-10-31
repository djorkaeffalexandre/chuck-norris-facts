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
        factsServiceMock = FactsServiceMock()
        searchFactsViewModel = SearchFactsViewModel(factsService: factsServiceMock)
    }

    override func tearDown() {
        disposeBag = nil
        testScheduler = nil
        searchFactsViewModel = nil
        factsServiceMock = nil
    }

    func test_SeachFactsViewModel_WhenSearchFacts_ShouldSetSearchTerm() {
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

    func test_SearchFactsViewModel_WhenCancelSearch_ShouldCancelSearchScene() {
        let cancelObserver = testScheduler.createObserver(Void.self)

        searchFactsViewModel.didCancel
            .subscribe(cancelObserver)
            .disposed(by: disposeBag)

        searchFactsViewModel.cancel.onNext(())

        testScheduler.start()

        let cancelCount = cancelObserver.events.compactMap { $0.value.element }.count
        XCTAssertEqual(cancelCount, 1)
    }

    func test_SearchFactsViewModel_WhenViewWillAppear_ShouldLoad8RandomSuggestions() throws {
        let searchFactsItemsObserver = testScheduler.createObserver([SearchFactsTableViewSection].self)

        let testCategories = try stub("get-categories", type: [FactCategory].self) ?? []
        factsServiceMock.retrieveCategoriesReturnValue = .just(testCategories)

        searchFactsViewModel.items
            .subscribe(searchFactsItemsObserver)
            .disposed(by: disposeBag)

        searchFactsViewModel.viewWillAppear.onNext(())

        testScheduler.start()

        let searchFactsViewModelEvents = searchFactsItemsObserver.events.compactMap { $0.value.element }.first
        XCTAssertEqual(searchFactsViewModelEvents?.first?.items.first?.quantity, 8)
    }

    func test_SearchFactsViewModel_WhenViewWillAppear_ShouldLoadPastSearches() {
        let searchFactsItemsObserver = testScheduler.createObserver([SearchFactsTableViewSection].self)

        let pastSearches = ["fashion", "games", "food"]
        factsServiceMock.retrievePastSearchesReturnValue = .just(pastSearches)

        searchFactsViewModel.items
            .subscribe(searchFactsItemsObserver)
            .disposed(by: disposeBag)

        searchFactsViewModel.viewWillAppear.onNext(())

        testScheduler.start()

        let searchFactsViewModelEvents = searchFactsItemsObserver.events.compactMap { $0.value.element }.first
        XCTAssertEqual(searchFactsViewModelEvents?.count, 1)
        XCTAssertEqual(searchFactsViewModelEvents?.first?.items.count, 3)
    }
}
