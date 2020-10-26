//
//  SearchFactsDataSource.swift
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

struct SearchFactsDataSource {
    typealias DataSource = RxTableViewSectionedReloadDataSource

    static func dataSource() -> DataSource<SearchFactsTableViewSection> {
        return .init(configureCell: { dataSource, tableView, indexPath, item -> UITableViewCell in

            switch dataSource[indexPath] {
            case .CategoryTableViewItem(let categories):
                let cell = FactCategoriesCell()
                cell.viewModel = FactCategoriesViewModel(categories: categories)
                return cell
            case .PastSearchTableViewItem(let model):
                let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
                cell.textLabel?.text = model.text
                cell.imageView?.image = UIImage(systemName: "magnifyingglass")
                return cell
            }

        }, titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].header
        })
    }
}
