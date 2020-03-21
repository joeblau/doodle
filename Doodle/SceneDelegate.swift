// SceneDelegate.swift
// Copyright (c) 2020 Joe Blau

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)

            window.rootViewController = DoodleViewController()
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
