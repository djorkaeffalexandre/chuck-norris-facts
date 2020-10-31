//
//  FactsServiceTests.swift
//  Chuck Norris FactsTests
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/21/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
import RxTest
import RealmSwift

@testable import Chuck_Norris_Facts

final class FactsServiceTests: XCTestCase {

    var factsService: FactsServiceType!
    var factsStorage: FactsStorageType!
    var factsProvider: APIMock!
    var realm: Realm!

    var disposeBag: DisposeBag!
    var testScheduler: TestScheduler!

    override func setUpWithError() throws {
        testScheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        realm = try Realm(configuration: .init(inMemoryIdentifier: self.name))
        factsStorage = FactsStorage(realm: realm)
        factsProvider = APIMock()
        factsService = FactsService(provider: factsProvider, storage: factsStorage, scheduler: MainScheduler.instance)
    }

    override func tearDown() {
        testScheduler = nil
        disposeBag = nil
        factsService = nil
        factsStorage = nil

        try? realm.write {
            realm.deleteAll()
        }
    }

    func test_FactsService_WhenSyncCategories_ShouldSaveCategoriesOnDatabase() throws {
        factsProvider.mockRequest(statusCode: 200, data: stub("get-categories"))

        let storedCategories = factsStorage.retrieveCategories()
        let categories = try storedCategories.toBlocking().first() ?? []
        XCTAssertTrue(categories.isEmpty)

        factsService.syncCategories()
            .subscribe()
            .disposed(by: disposeBag)

        let savedCategories = try storedCategories.toBlocking().first()
        XCTAssertEqual(savedCategories?.count, 16)
    }

    func test_FactsService_WhenSearchFacts_ShouldSaveSearchTermOnDatabase() throws {
        factsProvider.mockRequest(statusCode: 200, data: stub("search-facts"))

        let storedSearches = factsStorage.retrieveSearches()
        let searches = try storedSearches.toBlocking().first() ?? []
        XCTAssertTrue(searches.isEmpty)

        factsService.searchFacts(searchTerm: "games")
            .subscribe()
            .disposed(by: disposeBag)

        testScheduler.start()

        let savedSearches = try storedSearches.toBlocking().first()
        XCTAssertEqual(savedSearches?.count, 1)
    }

    func test_FactsService_WhenRetrieveCategories_ShouldReturnCategoriesOnDatabase() throws {
        let storedCategories = factsStorage.retrieveCategories()
        let categories = try storedCategories.toBlocking().first() ?? []
        XCTAssertTrue(categories.isEmpty)

        let stubCategories = try stub("get-categories", type: [FactCategory].self)
        let mockCategories = try XCTUnwrap(stubCategories)
        factsStorage.storeCategories(mockCategories)

        let savedCategories = try storedCategories.toBlocking().first()
        XCTAssertEqual(savedCategories?.count, mockCategories.count)
    }

    func test_FactsService_WhenSearchFacts_ShouldReturnFacts() throws {
        factsProvider.mockRequest(statusCode: 200, data: stub("search-facts"))

        let factsObserver = testScheduler.createObserver([Fact].self)

        factsService.searchFacts(searchTerm: "games")
            .subscribe(factsObserver)
            .disposed(by: disposeBag)

        testScheduler.start()

        let facts = factsObserver.events.compactMap { $0.value.element }.first
        XCTAssertEqual(facts?.count, 16)
    }

    func test_FactsService_WhenRetrievePastSearches_ShouldReturnDistinctSortedByDateSearches() throws {
        let storedSearches = factsStorage.retrieveSearches()
        let searches = try storedSearches.toBlocking().first() ?? []
        XCTAssertTrue(searches.isEmpty)

        factsStorage.storeSearch(searchTerm: "games")
        factsStorage.storeSearch(searchTerm: "explicit")
        factsStorage.storeSearch(searchTerm: "explicit")
        factsStorage.storeSearch(searchTerm: "fashion")

        let savedSearches = try storedSearches.toBlocking().first()
        XCTAssertEqual(savedSearches, ["fashion", "explicit", "games"])
    }
}
