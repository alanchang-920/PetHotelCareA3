//
//  NotificationManager.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/7.
//

import Foundation
import UserNotifications

final class NotificationManager {

    static let shared = NotificationManager()

    static let careTaskCategory =
        "CARE_TASK"

    private init() {}

    func requestAuthorization() {

        registerCategories()

        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .sound, .badge]
            ) { granted, error in

                if let error {
                    print(
                        "Notification permission error: \(error)"
                    )
                    return
                }

                print(
                    granted
                    ? "Notification permission granted"
                    : "Notification permission denied"
                )
            }
    }

    func scheduleCareTaskNotification(
        taskID: UUID,
        petName: String,
        taskType: String,
        scheduledTime: Date
    ) {

        guard scheduledTime > Date() else {
            return
        }

        let content =
            UNMutableNotificationContent()

        content.title = "Pet Hotel Care"

        content.body =
            "\(petName) has a \(taskType) task scheduled now."

        content.sound = .default

        content.categoryIdentifier =
            Self.careTaskCategory

        content.userInfo = [
            "petName": petName,
            "taskType": taskType
        ]

        let dateComponents =
            Calendar.current.dateComponents(
                [
                    .year,
                    .month,
                    .day,
                    .hour,
                    .minute
                ],
                from: scheduledTime
            )

        let trigger =
            UNCalendarNotificationTrigger(
                dateMatching: dateComponents,
                repeats: false
            )

        let request =
            UNNotificationRequest(
                identifier: taskID.uuidString,
                content: content,
                trigger: trigger
            )

        UNUserNotificationCenter.current()
            .add(request) { error in

                if let error {
                    print(
                        "Unable to schedule notification: \(error)"
                    )
                }
            }
    }

    private func registerCategories() {

        let careTaskCategory =
            UNNotificationCategory(
                identifier:
                    Self.careTaskCategory,
                actions: [],
                intentIdentifiers: [],
                options: []
            )

        UNUserNotificationCenter.current()
            .setNotificationCategories([
                careTaskCategory
            ])
    }
}
