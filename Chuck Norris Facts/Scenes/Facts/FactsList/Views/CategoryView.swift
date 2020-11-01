//
//  CategoryView.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/24/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit

class CategoryView: UIView {

    lazy var label: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .white
        label.numberOfLines = 1

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        layer.cornerRadius = 4
        backgroundColor = .systemBlue

        addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
    }
}
