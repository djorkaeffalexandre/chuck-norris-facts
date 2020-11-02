//
//  FactCategoryCell.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/20/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit

class FactCategoryCell: UICollectionViewCell {

    private let categoryView: CategoryView = CategoryView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()

        isAccessibilityElement = true
        accessibilityIdentifier = "factCategoryCell"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(_ factCategory: FactCategoryViewModel) {
        categoryView.label.text = factCategory.text.uppercased()
        categoryView.label.font = .preferredFont(forTextStyle: .headline)
    }

    func setupView() {
        contentView.addSubview(categoryView)
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        categoryView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        categoryView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    }
}
