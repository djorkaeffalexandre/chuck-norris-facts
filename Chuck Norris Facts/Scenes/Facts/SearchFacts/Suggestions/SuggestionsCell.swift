//
//  SuggestionsCell.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/26/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SuggestionsCell: UITableViewCell {

    static let identifier = "SuggestionsCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let disposeBag = DisposeBag()

    private lazy var suggestionsDataSource = RxCollectionViewSectionedReloadDataSource<SuggestionsSectionModel>(
        configureCell: { _, collectionView, indexPath, category -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FactCategoryCell.cellIdentifier,
                for: indexPath
            ) as? FactCategoryCell ?? FactCategoryCell()

            cell.setup(category)
            return cell
    }
    )

    var viewModel: SuggestionsViewModel! {
        didSet {
            self.setupBindings()
        }
    }

    lazy var collectionView: DynamicHeightCollectionView = {
        let layout = SuggestionsViewFlowLayout()
        let collectionView = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: layout)

        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FactCategoryCell.self, forCellWithReuseIdentifier: FactCategoryCell.cellIdentifier)

        return collectionView
    }()

    private func setupView() {
        contentView.addSubview(collectionView)

        collectionView.backgroundColor = .systemBackground
        collectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    }

    private func setupBindings() {
        collectionView
            .delegate = nil

        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        viewModel.suggestions
            .observeOn(MainScheduler.instance)
            .bind(to: collectionView.rx.items(dataSource: suggestionsDataSource))
            .disposed(by: disposeBag)

        let categorySelected = collectionView.rx
            .modelSelected(FactCategoryViewModel.self)
            .asObservable()

        categorySelected
            .compactMap { $0.text }
            .bind(to: viewModel.suggestion)
            .disposed(by: disposeBag)

        categorySelected
            .map { _ in () }
            .bind(to: viewModel.selectAction)
            .disposed(by: disposeBag)
    }
}

extension SuggestionsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = FactCategoryCell()
        let item = suggestionsDataSource.sectionModels[indexPath.section].items[indexPath.row]
        cell.setup(item)
        return cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
