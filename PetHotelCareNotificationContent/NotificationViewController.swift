//
//  NotificationViewController.swift
//  PetHotelCareNotificationContent
//
//  Created by Chang Chia ming on 2026/10/7.
//

import UIKit
import UserNotifications
import UserNotificationsUI

final class NotificationViewController:
    UIViewController,
    UNNotificationContentExtension {

    @IBOutlet private var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func didReceive(
        _ notification: UNNotification
    ) {
        let content =
            notification.request.content

        let petName =
            content.userInfo["petName"]
            as? String ?? "Pet"

        let taskType =
            content.userInfo["taskType"]
            as? String ?? "Care Task"

        label.text = """
        🐾 \(petName)

        \(taskType) Care Task

        \(content.body)
        """
    }
}
