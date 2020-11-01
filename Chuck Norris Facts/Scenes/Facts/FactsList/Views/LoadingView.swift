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
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.widthAnchor.constraint(equalToConstant: animationSize).isActive = true
        animation.heightAnchor.constraint(equalToConstant: animationSize).isActive = true
        animation.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        animation.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    func play() {
        animation.play()
    }

    func stop() {
        animation.stop()
    }
}
