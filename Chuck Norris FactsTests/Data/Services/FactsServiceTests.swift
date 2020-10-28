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
import Moya

@testable import Chuck_Norris_Facts

final class FactsServiceTests: XCTestCase {

    var factsService: FactsServiceType!
    var factsStorage: FactsStorageType!
    var factsProvider: MoyaProvider<FactsAPI>!
    var realm: Realm!

    var disposeBag: DisposeBag!
    var testScheduler: TestScheduler!

    override func setUpWithError() throws {
        testScheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        realm = try Realm(configuration: .init(inMemoryIdentifier: self.name))
        factsStorage = FactsStorage(realm: realm)
        factsProvider = MoyaProvider<FactsAPI>(stubClosure: MoyaProvider.immediatelyStub)
        factsService = FactsService(provider: factsProvider, storage: factsStorage)
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

    func test_syncCategoriesShouldSaveCategoriesOnStorage() throws {
        let storedCategories = factsStorage.retrieveCategories()
        let categories = try storedCategories.toBlocking().first() ?? []
        XCTAssertTrue(categories.isEmpty)

        factsService.syncCategories()
            .subscribe()
            .disposed(by: disposeBag)

        let savedCategories = try storedCategories.toBlocking().first()
        XCTAssertEqual(savedCategories?.count, 16)
    }

    func test_retrieveCategoriesShouldReturnCategoriesOnStorage() throws {
        let storedCategories = factsStorage.retrieveCategories()
        let categories = try storedCategories.toBlocking().first() ?? []
        XCTAssertTrue(categories.isEmpty)

        let stubCategories = try stub("get-categories", type: [FactCategory].self) ?? []
        factsStorage.storeCategories(stubCategories)

        let savedCategories = try storedCategories.toBlocking().first()
        XCTAssertEqual(savedCategories?.count, stubCategories.count)
    }

    func test_searchFactsShouldSaveFactsOnStorage() throws {
        let storedFacts = factsStorage.retrieveFacts(searchTerm: "")
        let facts = try storedFacts.toBlocking().first() ?? []
        XCTAssertTrue(facts.isEmpty)

        factsService.searchFacts(searchTerm: "")
            .subscribe()
            .disposed(by: disposeBag)

        let savedFacts = try storedFacts.toBlocking().first()
        XCTAssertEqual(savedFacts?.count, 16)
    }

    func test_retrieveFactsShouldReturnFactsOnStorage() throws {
        let storedFacts = factsStorage.retrieveFacts(searchTerm: "")
        let facts = try storedFacts.toBlocking().first() ?? []
        XCTAssertTrue(facts.isEmpty)

        let stubFacts = try stub("facts-list", type: [Fact].self) ?? []
        factsStorage.storeFacts(stubFacts)

        let savedFacts = try storedFacts.toBlocking().first()
        XCTAssertEqual(savedFacts?.count, stubFacts.count)
    }

    func test_retrievePastSearchesShouldReturnDistinctSortedByDateSearchesOnStorage() throws {
        let storedSearches = factsStorage.retrieveSearches()
        let searches = try storedSearches.toBlocking().first() ?? []
        XCTAssertTrue(searches.isEmpty)

        let stubShortFact = try stub("short-fact", type: Fact.self)
        let shortFact = try XCTUnwrap(stubShortFact)

        let stubLongFact = try stub("long-fact", type: Fact.self)
        let longFact = try XCTUnwrap(stubLongFact)

        factsStorage.storeSearch(searchTerm: "games", facts: [shortFact])
        factsStorage.storeSearch(searchTerm: "explicit", facts: [longFact])
        factsStorage.storeSearch(searchTerm: "explicit", facts: [longFact])
        factsStorage.storeSearch(searchTerm: "fashion", facts: [shortFact])

        let savedSearches = try storedSearches.toBlocking().first()
        XCTAssertEqual(savedSearches, ["fashion", "explicit", "games"])
    }
}
