//
//  AppDelegate.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/7.
//

import UIKit

final class AppDelegate: NSObject,
                         UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        configurationForConnecting
            connectingSceneSession:
                UISceneSession,
        options:
            UIScene.ConnectionOptions
    ) -> UISceneConfiguration {

        let configuration =
            UISceneConfiguration(
                name: nil,
                sessionRole:
                    connectingSceneSession.role
            )

        if connectingSceneSession.role ==
            .windowApplication {

            configuration.delegateClass =
                SceneDelegate.self
        }

        return configuration
    }
}
