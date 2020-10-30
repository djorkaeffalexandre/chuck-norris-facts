//
//  FactCategoryCell.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/20/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit

class FactCategoryCell: UICollectionViewCell {

    private lazy var bodyLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white

        return label
    }()

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
        bodyLabel.text = factCategory.text
        bodyLabel.font = .systemFont(ofSize: 16, weight: .bold)
    }

    func setupView() {
        layer.cornerRadius = 4

        backgroundColor = .systemBlue

        contentView.addSubview(bodyLabel)
        bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4).isActive = true
        bodyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
    }
}
