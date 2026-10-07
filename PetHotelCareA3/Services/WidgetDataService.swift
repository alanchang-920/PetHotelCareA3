//
//  WidgetDataService.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/7.
//

import Foundation
import WidgetKit

final class WidgetDataService {

    static let shared = WidgetDataService()

    private let appGroupIdentifier =
        "group.student.uts.edu.au.PetHotelCareA3"

    private let widgetKind =
        "PetHotelCareWidget"

    private init() {}

    func updateWidget(
        with tasks: [CareTask],
        referenceDate: Date = Date()
    ) {
        guard let defaults = UserDefaults(
            suiteName: appGroupIdentifier
        ) else {
            return
        }

        let calendar = Calendar.current

        let todaysPendingTasks = tasks
            .filter { task in
                calendar.isDate(
                    task.scheduledTime,
                    inSameDayAs: referenceDate
                ) &&
                task.isCompleted == false
            }
            .sorted {
                $0.scheduledTime < $1.scheduledTime
            }

        defaults.set(
            todaysPendingTasks.count,
            forKey: "widget.pendingTaskCount"
        )

        if let nextTask = todaysPendingTasks.first {
            defaults.set(
                displayName(for: nextTask.type),
                forKey: "widget.nextTaskType"
            )

            defaults.set(
                formattedTime(nextTask.scheduledTime),
                forKey: "widget.nextTaskTime"
            )
        } else {
            defaults.set(
                "",
                forKey: "widget.nextTaskType"
            )

            defaults.set(
                "",
                forKey: "widget.nextTaskTime"
            )
        }

        WidgetCenter.shared.reloadTimelines(
            ofKind: widgetKind
        )
    }

    func updateNextPetName(
        _ petName: String
    ) {
        guard let defaults = UserDefaults(
            suiteName: appGroupIdentifier
        ) else {
            return
        }

        defaults.set(
            petName,
            forKey: "widget.nextPetName"
        )

        WidgetCenter.shared.reloadTimelines(
            ofKind: widgetKind
        )
    }

    func clearWidget() {
        guard let defaults = UserDefaults(
            suiteName: appGroupIdentifier
        ) else {
            return
        }

        defaults.set(
            0,
            forKey: "widget.pendingTaskCount"
        )

        defaults.set(
            "",
            forKey: "widget.nextPetName"
        )

        defaults.set(
            "",
            forKey: "widget.nextTaskType"
        )

        defaults.set(
            "",
            forKey: "widget.nextTaskTime"
        )

        WidgetCenter.shared.reloadTimelines(
            ofKind: widgetKind
        )
    }

    private func displayName(
        for type: CareTaskType
    ) -> String {
        switch type {
        case .feeding:
            return "Feeding"

        case .walk:
            return "Walk"

        case .medication:
            return "Medication"
        }
    }

    private func formattedTime(
        _ date: Date
    ) -> String {
        date.formatted(
            date: .omitted,
            time: .shortened
        )
    }
}
