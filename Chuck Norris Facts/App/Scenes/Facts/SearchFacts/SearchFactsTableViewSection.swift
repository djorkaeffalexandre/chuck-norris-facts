//
//  SearchFactsTableViewSection.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/26/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import RxDataSources

enum SearchFactsTableViewItem {
    case SuggestionsTableViewItem(suggestions: [FactCategoryViewModel])
    case PastSearchTableViewItem(pastSearch: PastSearchViewModel)
}

extension SearchFactsTableViewItem {
    var text: String {
        switch self {
        case .SuggestionsTableViewItem:
            return ""
        case .PastSearchTableViewItem(let pastSearch):
            return pastSearch.text
        }
    }
}

enum SearchFactsTableViewSection {
    case SuggestionsSection(items: [SearchFactsTableViewItem])
    case PastSearchesSection(items: [SearchFactsTableViewItem])
}

extension SearchFactsTableViewSection: SectionModelType {
    typealias Item = SearchFactsTableViewItem

    var header: String {
        switch self {
        case .SuggestionsSection:
            return L10n.SearchFacts.Sections.suggestions
        case .PastSearchesSection:
            return L10n.SearchFacts.Sections.pastSearches
        }
    }

    var items: [SearchFactsTableViewItem] {
        switch self {
        case .SuggestionsSection(let items):
            return items
        case .PastSearchesSection(let items):
            return items
        }
    }

    var isEmpty: Bool {
        switch self {
        case .SuggestionsSection(let items):
            switch items.first {
            case .SuggestionsTableViewItem(let suggestions):
                return suggestions.isEmpty
            default:
                return true
            }
        case .PastSearchesSection(let items):
            return items.isEmpty
        }
    }

    var count: Int {
        switch self {
        case .SuggestionsSection(let items):
            switch items.first {
            case .SuggestionsTableViewItem(let suggestions):
                return suggestions.count
            default:
                return 0
            }
        case .PastSearchesSection(let items):
            return items.count
        }
    }

    init(original: Self, items: [Self.Item]) {
        self = original
    }
}
