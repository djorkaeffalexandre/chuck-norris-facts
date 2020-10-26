//
//  FactCategoriesCell.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/26/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class FactCategoriesCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let disposeBag = DisposeBag()

    private lazy var categoriesDataSource = RxCollectionViewSectionedReloadDataSource<FactCategoriesSectionModel>(
        configureCell: { _, collectionView, indexPath, category -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FactCategoryCell.cellIdentifier,
                for: indexPath
            )
            if let cell = cell as? FactCategoryCell {
                cell.setup(category)
            }
            return cell
    }
    )

    var viewModel: FactCategoriesViewModel! {
        didSet {
            self.setupBindings()
        }
    }

    lazy var collectionView: DynamicHeightCollectionView = {
        let layout = FactCategoryViewFlowLayout()
        let collectionView = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: layout)

        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        collectionView.delegate = self
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
        viewModel.categories
            .observeOn(MainScheduler.instance)
            .bind(to: collectionView.rx.items(dataSource: categoriesDataSource))
            .disposed(by: disposeBag)
    }
}

extension FactCategoriesCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = FactCategoryCell()
        let item = categoriesDataSource.sectionModels[indexPath.section].items[indexPath.row]
        cell.setup(item)
        return cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
