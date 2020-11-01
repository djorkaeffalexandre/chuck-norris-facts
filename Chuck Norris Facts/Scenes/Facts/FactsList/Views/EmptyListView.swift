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

        animation.animation = Animation.named("empty-box")
        animation.loopMode = .loop

        return animation
    }()

    lazy var label: UILabel = {
        let label = UILabel()

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

        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.widthAnchor.constraint(equalToConstant: animationSize).isActive = true
        animation.heightAnchor.constraint(equalToConstant: animationSize).isActive = true
        animation.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        animation.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: animation.bottomAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: animation.centerXAnchor).isActive = true

        addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        searchButton.centerXAnchor.constraint(equalTo: label.centerXAnchor).isActive = true

        accessibilityIdentifier = "emptyListView"
        label.accessibilityIdentifier = "emptyListLabelView"
    }

    func play() {
        animation.play()
    }

    func stop() {
        animation.stop()
    }
}
