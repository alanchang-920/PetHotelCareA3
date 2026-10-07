//
//  PetHotelCareWidget.swift
//  PetHotelCareWidget
//
//  Created by Chang Chia ming on 2026/10/7.
//

import WidgetKit
import SwiftUI

struct PetHotelWidgetData {
    let pendingTaskCount: Int
    let nextPetName: String
    let nextTaskType: String
    let nextTaskTime: String

    static let placeholder = PetHotelWidgetData(
        pendingTaskCount: 3,
        nextPetName: "Hana",
        nextTaskType: "Feeding",
        nextTaskTime: "2:30 PM"
    )

    static let empty = PetHotelWidgetData(
        pendingTaskCount: 0,
        nextPetName: "",
        nextTaskType: "",
        nextTaskTime: ""
    )
}

struct PetHotelCareEntry: TimelineEntry {
    let date: Date
    let data: PetHotelWidgetData
}

struct PetHotelCareProvider: TimelineProvider {

    private let appGroupIdentifier =
        "group.student.uts.edu.au.PetHotelCareA3"

    func placeholder(
        in context: Context
    ) -> PetHotelCareEntry {
        PetHotelCareEntry(
            date: Date(),
            data: .placeholder
        )
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (PetHotelCareEntry) -> Void
    ) {
        let data = context.isPreview
            ? PetHotelWidgetData.placeholder
            : loadSharedData()

        let entry = PetHotelCareEntry(
            date: Date(),
            data: data
        )

        completion(entry)
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<PetHotelCareEntry>) -> Void
    ) {
        let data = loadSharedData()

        let entry = PetHotelCareEntry(
            date: Date(),
            data: data
        )

        let nextRefresh =
            Calendar.current.date(
                byAdding: .minute,
                value: 15,
                to: Date()
            ) ?? Date().addingTimeInterval(900)

        let timeline = Timeline(
            entries: [entry],
            policy: .after(nextRefresh)
        )

        completion(timeline)
    }

    private func loadSharedData() -> PetHotelWidgetData {
        guard let defaults = UserDefaults(
            suiteName: appGroupIdentifier
        ) else {
            return .empty
        }

        let pendingTaskCount =
            defaults.integer(
                forKey: "widget.pendingTaskCount"
            )

        let nextPetName =
            defaults.string(
                forKey: "widget.nextPetName"
            ) ?? ""

        let nextTaskType =
            defaults.string(
                forKey: "widget.nextTaskType"
            ) ?? ""

        let nextTaskTime =
            defaults.string(
                forKey: "widget.nextTaskTime"
            ) ?? ""

        return PetHotelWidgetData(
            pendingTaskCount: pendingTaskCount,
            nextPetName: nextPetName,
            nextTaskType: nextTaskType,
            nextTaskTime: nextTaskTime
        )
    }
}

struct PetHotelCareWidgetEntryView: View {

    @Environment(\.widgetFamily)
    private var family

    let entry: PetHotelCareProvider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            smallWidget

        case .systemMedium:
            mediumWidget

        default:
            smallWidget
        }
    }

    private var smallWidget: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            HStack {
                Image(systemName: "pawprint.fill")

                Text("Pet Hotel")
                    .font(.headline)
            }

            Spacer()

            Text("\(entry.data.pendingTaskCount)")
                .font(.system(
                    size: 36,
                    weight: .bold
                ))

            Text(
                entry.data.pendingTaskCount == 1
                    ? "Pending Task"
                    : "Pending Tasks"
            )
            .font(.caption)
            .foregroundStyle(.secondary)

            Spacer()

            if entry.data.pendingTaskCount == 0 {
                Label(
                    "All care complete",
                    systemImage: "checkmark.circle.fill"
                )
                .font(.caption)
            } else {
                Text("Today's Care")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .containerBackground(
            .fill.tertiary,
            for: .widget
        )
    }

    private var mediumWidget: some View {
        HStack(spacing: 16) {

            VStack(
                alignment: .leading,
                spacing: 6
            ) {
                HStack {
                    Image(systemName: "pawprint.fill")

                    Text("Today's Care")
                        .font(.headline)
                }

                Spacer()

                Text("\(entry.data.pendingTaskCount)")
                    .font(.system(
                        size: 34,
                        weight: .bold
                    ))

                Text(
                    entry.data.pendingTaskCount == 1
                        ? "Pending Task"
                        : "Pending Tasks"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Divider()

            VStack(
                alignment: .leading,
                spacing: 6
            ) {
                Text("Next Care")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if entry.data.pendingTaskCount == 0 {
                    Spacer()

                    Label(
                        "All care tasks complete",
                        systemImage: "checkmark.circle.fill"
                    )
                    .font(.subheadline)

                    Spacer()
                } else if entry.data.nextPetName.isEmpty {
                    Spacer()

                    Text("Open Pet Hotel Care")
                        .font(.subheadline)

                    Text("to review pending tasks")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Spacer()
                } else {
                    Text(entry.data.nextPetName)
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text(entry.data.nextTaskType)
                        .font(.subheadline)

                    Spacer()

                    Label(
                        entry.data.nextTaskTime,
                        systemImage: "clock"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .containerBackground(
            .fill.tertiary,
            for: .widget
        )
    }
}

struct PetHotelCareWidget: Widget {

    let kind = "PetHotelCareWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: PetHotelCareProvider()
        ) { entry in
            PetHotelCareWidgetEntryView(
                entry: entry
            )
        }
        .configurationDisplayName(
            "Pet Hotel Care"
        )
        .description(
            "See today's pending pet care tasks and the next scheduled activity."
        )
        .supportedFamilies([
            .systemSmall,
            .systemMedium
        ])
    }
}

#Preview(
    as: .systemSmall
) {
    PetHotelCareWidget()
} timeline: {
    PetHotelCareEntry(
        date: .now,
        data: .placeholder
    )
}

#Preview(
    as: .systemMedium
) {
    PetHotelCareWidget()
} timeline: {
    PetHotelCareEntry(
        date: .now,
        data: .placeholder
    )
}
