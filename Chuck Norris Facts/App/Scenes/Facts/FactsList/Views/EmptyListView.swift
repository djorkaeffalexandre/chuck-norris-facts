//
//  EmptyView.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/10/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit
import Lottie

final class EmptyListView: UIView {

    private lazy var animation: AnimationView = {
        let animation = AnimationView()

        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.animation = Animation.named("empty-box")
        animation.loopMode = .loop

        return animation
    }()

    lazy var label: UILabel = {
        let label = UILabel()

        label.accessibilityIdentifier = "emptyListLabelView"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0

        return label
    }()

    lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "Search"
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.accessibilityIdentifier = "searchButton"

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        let animationSize: CGFloat = 200

        backgroundColor = .systemBackground

        addSubview(animation)
        NSLayoutConstraint.activate([
            animation.widthAnchor.constraint(equalToConstant: animationSize),
            animation.heightAnchor.constraint(equalToConstant: animationSize),
            animation.centerXAnchor.constraint(equalTo: centerXAnchor),
            animation.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: animation.bottomAnchor),
            label.centerXAnchor.constraint(equalTo: animation.centerXAnchor)
        ])

        addSubview(searchButton)
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: label.bottomAnchor),
            searchButton.centerXAnchor.constraint(equalTo: label.centerXAnchor)
        ])

        accessibilityIdentifier = "emptyListView"
    }

    func play() {
        animation.play()
    }

    func stop() {
        animation.stop()
    }
}
