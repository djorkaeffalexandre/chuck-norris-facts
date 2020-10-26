//
//  FactCategoriesViewModel.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/26/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import RxSwift

struct FactCategoriesViewModel {

    let categories: Observable<[FactCategoriesSectionModel]>

    init(categories: [FactCategoriesSectionModel]) {
        let categoriesSubject = BehaviorSubject<[FactCategoriesSectionModel]>(value: [])
        self.categories = categoriesSubject.asObserver()

        categoriesSubject.onNext(categories)
    }
}
