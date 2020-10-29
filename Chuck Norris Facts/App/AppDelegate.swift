//
//  AppDelegate.swift
//  Chuck Norris Facts
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 10/9/20.
//  Copyright © 2020 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        processArguments()

        return true
    }

    private func processArguments() {
        if LaunchArgument.check(.uiTest) {
            UIView.setAnimationsEnabled(false)
        }

        if LaunchArgument.check(.resetData) {
            let realm = try? Realm()
            try? realm?.write {
                realm?.deleteAll()
            }
        }

        if LaunchArgument.check(.mockStorage) {
            let facts = Data.stub("facts", type: [Fact].self) ?? []

            let entities = [
                SearchEntity(searchTerm: "games", facts: facts),
                SearchEntity(searchTerm: "fashion", facts: facts)
            ]

            let realm = try? Realm()
            try? realm?.write {
                realm?.add(entities, update: .modified)
            }
        }
    }
}
