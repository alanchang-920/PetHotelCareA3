//
//  QuickActionManager.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/7.
//

import UIKit
import Combine

@MainActor
final class QuickActionManager: ObservableObject {

    static let shared = QuickActionManager()

    static let todayCareType =
        "student.uts.edu.au.PetHotelCareA3.todayCare"

    static let currentStaysType =
        "student.uts.edu.au.PetHotelCareA3.currentStays"

    @Published var selectedTab: Int?

    private init() {}

    static func configure() {

        let todayCare = UIApplicationShortcutItem(
            type: todayCareType,
            localizedTitle: "Today's Care",
            localizedSubtitle: "View today's care tasks",
            icon: UIApplicationShortcutIcon(
                systemImageName: "checklist"
            )
        )

        let currentStays = UIApplicationShortcutItem(
            type: currentStaysType,
            localizedTitle: "Current Stays",
            localizedSubtitle: "View current pet stays",
            icon: UIApplicationShortcutIcon(
                systemImageName: "house"
            )
        )

        UIApplication.shared.shortcutItems = [
            todayCare,
            currentStays
        ]
    }

    func handle(
        _ shortcutItem: UIApplicationShortcutItem
    ) -> Bool {

        switch shortcutItem.type {

        case Self.todayCareType:
            selectedTab = 0
            return true

        case Self.currentStaysType:
            selectedTab = 1
            return true

        default:
            return false
        }
    }
}
