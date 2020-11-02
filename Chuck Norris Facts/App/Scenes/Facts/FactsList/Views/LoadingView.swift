//
//  LoadingView.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/27/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit
import Lottie

final class LoadingView: UIView {

    private lazy var animation: AnimationView = {
        let loading = AnimationView()

        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.animation = Animation.named("loading")
        loading.loopMode = .loop

        return loading
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        let animationSize: CGFloat = 48

        backgroundColor = .systemBackground

        addSubview(animation)
        NSLayoutConstraint.activate([
            animation.widthAnchor.constraint(equalToConstant: animationSize),
            animation.heightAnchor.constraint(equalToConstant: animationSize),
            animation.centerXAnchor.constraint(equalTo: centerXAnchor),
            animation.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func play() {
        animation.play()
    }

    func stop() {
        animation.stop()
    }
}
