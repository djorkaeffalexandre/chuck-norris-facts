//
//  PastSearchCell.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/26/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit

class PastSearchCell: UITableViewCell {

    static let identifier = "PastSearchCell"

    func setup(_ pastSearch: PastSearchViewModel) {
        textLabel?.text = pastSearch.text
        imageView?.image = UIImage(systemName: "magnifyingglass")
    }
}
