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
        label.font = .systemFont(ofSize: 16, weight: .semibold)

        return label
    }()

    lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "Retry"
        button.setTitle("Retry", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.accessibilityIdentifier = "retryButton"

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
        backgroundColor = .systemBackground

        addSubview(animation)
        animation.widthAnchor.constraint(equalToConstant: 200).isActive = true
        animation.heightAnchor.constraint(equalToConstant: 200).isActive = true
        animation.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        animation.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        addSubview(label)
        label.topAnchor.constraint(equalTo: animation.bottomAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: widthAnchor, constant: -16).isActive = true
        label.centerXAnchor.constraint(equalTo: animation.centerXAnchor).isActive = true

        addSubview(retryButton)
        retryButton.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        retryButton.centerXAnchor.constraint(equalTo: label.centerXAnchor).isActive = true
    }

    func play() {
        animation.play()
    }
}
