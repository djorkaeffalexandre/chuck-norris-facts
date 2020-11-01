//
//  FactCell.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/10/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit
import RxSwift

class FactCell: UITableViewCell {

    private let categoryView = CategoryView()

    var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }

    private lazy var shadowView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground

        view.layer.shadowColor = UIColor.systemGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = .zero
        view.layer.cornerRadius = 16

        return view
    }()

    lazy var bodyLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0

        return label
    }()

    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "Share"
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.accessibilityIdentifier = "shareFactButton"

        return button
    }()

    private func setupView() {
        let padding: CGFloat = 16

        clipsToBounds = false
        selectionStyle = .none

        contentView.clipsToBounds = false
        contentView.addSubview(shadowView)

        shadowView.addSubview(bodyLabel)
        shadowView.addSubview(shareButton)
        shadowView.addSubview(categoryView)

        shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding).isActive = true
        shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
        shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding / 2).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding / 2).isActive = true

        bodyLabel.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: padding).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: padding).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -padding).isActive = true

        shareButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: padding).isActive = true
        shareButton.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -padding).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -padding).isActive = true

        categoryView.translatesAutoresizingMaskIntoConstraints = false
        categoryView.centerYAnchor.constraint(equalTo: shareButton.centerYAnchor).isActive = true
        categoryView.leftAnchor.constraint(equalTo: shadowView.leftAnchor, constant: padding).isActive = true
    }

    func setup(_ fact: FactViewModel) {
        bodyLabel.text = fact.text

        bodyLabel.font = fact.text.count > 80
            ? UIFont.preferredFont(forTextStyle: .title3)
            : UIFont.preferredFont(forTextStyle: .title1)

        categoryView.label.text = fact.category
    }
}
