//
//  FactTableViewCell.swift
//  Chuck
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/10/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit

class FactTableViewCell: UITableViewCell {

    static let cellIdentifier = "FactTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    private lazy var bodyLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0

        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)

        return label
    }()

    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "Share"
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)

        return button
    }()

    private func setupView() {
        clipsToBounds = false
        selectionStyle = .none

        contentView.clipsToBounds = false
        contentView.addSubview(shadowView)

        shadowView.addSubview(bodyLabel)
        shadowView.addSubview(shareButton)

        shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16 / 2).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16 / 2).isActive = true

        bodyLabel.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 16).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 16).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -16).isActive = true

        shareButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor).isActive = true
        shareButton.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -16).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -16).isActive = true
    }

    func setup(_ fact: FactViewModel) {
        bodyLabel.text = fact.text
        bodyLabel.font = .systemFont(ofSize: CGFloat(fact.textSize.rawValue), weight: .bold)
    }
}
