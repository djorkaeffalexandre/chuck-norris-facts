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

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(animation)

        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        animation.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        animation.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        animation.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func play() {
        animation.play()
    }

    func stop() {
        animation.stop()
    }
}
