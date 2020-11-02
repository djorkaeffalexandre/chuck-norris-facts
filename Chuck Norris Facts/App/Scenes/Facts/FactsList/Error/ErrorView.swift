//
//  ErrorView.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/28/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit
import Lottie

final class ErrorView: UIView {

    private lazy var animation: AnimationView = {
        let loading = AnimationView()

        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.animation = Animation.named("error")

        return loading
    }()

    lazy var label: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .headline)

        return label
    }()

    lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "Retry"
        button.setTitle(L10n.ErrorView.retry, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.accessibilityIdentifier = "retryButton"

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()

        accessibilityIdentifier = "errorView"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        let animationSize: CGFloat = 200
        let padding: CGFloat = 16

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
            label.widthAnchor.constraint(equalTo: widthAnchor, constant: -padding),
            label.centerXAnchor.constraint(equalTo: animation.centerXAnchor)
        ])

        addSubview(retryButton)
        NSLayoutConstraint.activate([
            retryButton.topAnchor.constraint(equalTo: label.bottomAnchor),
            retryButton.centerXAnchor.constraint(equalTo: label.centerXAnchor)
        ])
    }

    func play() {
        animation.play()
    }
}
