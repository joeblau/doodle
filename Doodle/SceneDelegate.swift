// SceneDelegate.swift
// Copyright (c) 2020 Joe Blau

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)

            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().backgroundColor = .clear
            UINavigationBar.appearance().isTranslucent = true

            window.rootViewController = UINavigationController(rootViewController: DoodleViewController())
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
