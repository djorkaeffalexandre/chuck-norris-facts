//
//  FactCategoriesViewModel.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/26/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import RxSwift

struct FactCategoriesViewModel {

    // MARK: - Inputs

    let category: AnyObserver<String>

    let selectAction: AnyObserver<Void>

    // MARK: - Outputs

    let categories: Observable<[FactCategoriesSectionModel]>

    let didSelectCategory: Observable<String>

    init(categories: [FactCategoriesSectionModel]) {
        let categoriesSubject = BehaviorSubject<[FactCategoriesSectionModel]>(value: [])
        self.categories = categoriesSubject.asObserver()

        categoriesSubject.onNext(categories)

        let categorySubject = BehaviorSubject<String>(value: "")
        self.category = categorySubject.asObserver()

        let selectActionSubject = PublishSubject<Void>()
        self.selectAction = selectActionSubject.asObserver()

        self.didSelectCategory = selectActionSubject
            .withLatestFrom(categorySubject)
            .filter { !$0.isEmpty }
    }
}
