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
    var viewModel: FactsListViewModel!
    var testScheduler: TestScheduler!

    var disposeBag: DisposeBag!

    override func setUp() {
        disposeBag = DisposeBag()

        testScheduler = TestScheduler(initialClock: 0)

        viewModel = FactsListViewModel()
    }

    override func tearDown() {
        disposeBag = nil
        testScheduler = nil
        viewModel = nil
    }

    func test_showShareFact() throws {
        guard let file = Bundle.main.url(forResource: "large-fact", withExtension: ".json") else {
            return
        }

        let data = try Data(contentsOf: file)

        let fact = try JSON.decoder.decode(Fact.self, from: data)
        let factObserver = testScheduler.createObserver(FactViewModel.self)

        viewModel.showShareFact
            .subscribe(factObserver)
            .disposed(by: disposeBag)

        let factViewModel = FactViewModel(fact: fact)
        viewModel.startShareFact.onNext(factViewModel)

        let shareFact = factObserver.events.compactMap { $0.value.element }.first
        XCTAssertEqual(fact.value, shareFact?.text)
    }
}
