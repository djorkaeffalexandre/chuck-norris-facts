//
//  SearchFactsTableViewSection.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/26/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import RxDataSources

enum SearchFactsTableViewItem {
    case CategoryTableViewItem(categories: [FactCategoriesSectionModel])
    case PastSearchTableViewItem(model: PastSearchViewModel)
}

enum SearchFactsTableViewSection {
    case CategoriesSection(items: [SearchFactsTableViewItem])
    case PastSearchesSection(items: [SearchFactsTableViewItem])
}

extension SearchFactsTableViewSection: SectionModelType {
    typealias Item = SearchFactsTableViewItem

    var header: String {
        switch self {
        case .CategoriesSection:
            return "Suggestions"
        case .PastSearchesSection:
            return "Past Searches"
        }
    }

    var items: [SearchFactsTableViewItem] {
        switch self {
        case .CategoriesSection(let items):
            return items
        case .PastSearchesSection(let items):
            return items
        }
    }

    init(original: Self, items: [Self.Item]) {
        self = original
    }
}
