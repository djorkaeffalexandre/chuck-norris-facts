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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }

    private lazy var suggestionsDataSource = RxCollectionViewSectionedReloadDataSource<SuggestionsSectionModel>(
        configureCell: { _, collectionView, indexPath, category -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(cell: FactCategoryCell.self, indexPath: indexPath)
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
        let insets: CGFloat = 16

        let suggestionsViewFlowLayout = SuggestionsViewFlowLayout()
        let collectionView = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: suggestionsViewFlowLayout)

        suggestionsViewFlowLayout.scrollDirection = .vertical
        suggestionsViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        suggestionsViewFlowLayout.sectionInset = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)

        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FactCategoryCell.self)

        return collectionView
    }()

    private func setupView() {
        contentView.addSubview(collectionView)

        collectionView.backgroundColor = .systemBackground
        collectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    }

    private func setupBindings() {
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        viewModel.outputs.suggestions
            .observeOn(MainScheduler.instance)
            .bind(to: collectionView.rx.items(dataSource: suggestionsDataSource))
            .disposed(by: disposeBag)

        let suggestionSelected = collectionView.rx
            .modelSelected(FactCategoryViewModel.self)
            .asObservable()

        suggestionSelected
            .compactMap { $0.text }
            .bind(to: viewModel.inputs.selectSuggestion)
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
