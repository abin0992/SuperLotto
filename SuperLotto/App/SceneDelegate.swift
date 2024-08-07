//
//  SceneDelegate.swift
//  SuperLotto
//
//  Created by Abin Baby on 07/08/2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var applicationCoordintor: ApplicationCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let applicationCoordintor = ApplicationCoordinator(
                window: window
            )
            applicationCoordintor.start()

            self.applicationCoordintor = applicationCoordintor
            window.makeKeyAndVisible()
        }
    }
}

