//
//  SceneDelegate.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/7.
//

import UIKit

final class SceneDelegate: NSObject,
                           UIWindowSceneDelegate {

    private var pendingShortcutItem:
        UIApplicationShortcutItem?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions:
            UIScene.ConnectionOptions
    ) {

        pendingShortcutItem =
            connectionOptions.shortcutItem
    }

    func sceneDidBecomeActive(
        _ scene: UIScene
    ) {

        guard let shortcutItem =
                pendingShortcutItem else {
            return
        }

        pendingShortcutItem = nil

        Task { @MainActor in
            _ = QuickActionManager.shared.handle(
                shortcutItem
            )
        }
    }

    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem:
            UIApplicationShortcutItem,
        completionHandler:
            @escaping (Bool) -> Void
    ) {

        Task { @MainActor in

            let handled =
                QuickActionManager.shared.handle(
                    shortcutItem
                )

            completionHandler(handled)
        }
    }
}
