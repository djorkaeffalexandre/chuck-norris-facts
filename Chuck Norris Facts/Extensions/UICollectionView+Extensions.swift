//
//  UICollectionView+Extensions.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/28/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register(_ cell: UICollectionViewCell.Type) {
        register(cell, forCellWithReuseIdentifier: String(describing: cell.self))
    }

    func dequeueReusableCell<T: UICollectionViewCell>(cell: T.Type, indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T ?? T()
    }
}
