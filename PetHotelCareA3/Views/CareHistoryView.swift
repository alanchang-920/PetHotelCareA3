//
//  CareHistoryView.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/5.
//

import SwiftUI

struct CareHistoryView: View {

    let petStayID: UUID

    @ObservedObject var viewModel: CareHistoryViewModel

    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 20
            ) {

                headerSection

                contentSection
            }
            .padding()
        }
        .navigationTitle("Care History")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadHistory(
                for: petStayID
            )
        }
    }
}

private extension CareHistoryView {

    var headerSection: some View {
        HStack {

            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text("Care History")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Completed care activities for this stay")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(spacing: 2) {

                Text("\(viewModel.records.count)")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Records")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Color(.secondarySystemBackground)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 14
                )
            )
        }
    }

    @ViewBuilder
    var contentSection: some View {

        if viewModel.isLoading {

            loadingView

        } else if let errorMessage =
                    viewModel.errorMessage {

            errorView(
                message: errorMessage
            )

        } else if viewModel.records.isEmpty {

            emptyState

        } else {

            historySection
        }
    }

    var historySection: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            Text("Completed Activities")
                .font(.headline)

            ForEach(viewModel.records) { record in

                historyCard(
                    record
                )
            }
        }
    }

    func historyCard(
        _ record: CareActivityRecord
    ) -> some View {

        HStack(
            alignment: .top,
            spacing: 14
        ) {

            ZStack {

                Circle()
                    .fill(
                        Color(.systemGray5)
                    )
                    .frame(
                        width: 42,
                        height: 42
                    )

                Image(
                    systemName:
                        iconName(
                            for: record.taskType
                        )
                )
                .font(.headline)
            }

            VStack(
                alignment: .leading,
                spacing: 5
            ) {

                Text(
                    taskTitle(
                        for: record.taskType
                    )
                )
                .font(.headline)

                Label(
                    "Completed by \(record.completedBy.name)",
                    systemImage: "person"
                )
                .font(.caption)
                .foregroundStyle(.secondary)

                if !record.notes
                    .trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )
                    .isEmpty {

                    Text(record.notes)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 2)
                }
            }

            Spacer()

            VStack(
                alignment: .trailing,
                spacing: 4
            ) {

                Text(
                    record.completedAt,
                    format: .dateTime
                        .hour()
                        .minute()
                )
                .font(.subheadline)
                .fontWeight(.semibold)

                Text(
                    record.completedAt,
                    format: .dateTime
                        .month(.abbreviated)
                        .day()
                )
                .font(.caption2)
                .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(
            Color(.secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16
            )
        )
    }

    var loadingView: some View {
        VStack(spacing: 12) {

            ProgressView()

            Text("Loading care history...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 180
        )
    }

    var emptyState: some View {
        VStack(spacing: 12) {

            Image(
                systemName: "clock.arrow.circlepath"
            )
            .font(.largeTitle)

            Text("No Care History")
                .font(.headline)

            Text(
                "Completed care activities will appear here."
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 220
        )
    }

    func errorView(
        message: String
    ) -> some View {

        VStack(spacing: 12) {

            Image(
                systemName: "exclamationmark.triangle"
            )
            .font(.title)

            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                viewModel.loadHistory(
                    for: petStayID
                )
            }
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 180
        )
    }

    func taskTitle(
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

    func iconName(
        for type: CareTaskType
    ) -> String {

        switch type {

        case .feeding:
            return "fork.knife"

        case .walk:
            return "figure.walk"

        case .medication:
            return "pills"
        }
    }
}

#Preview("Care History") {

    let petStayID = UUID()

    let staff = StaffMember(
        name: "Alex"
    )

    let calendar = Calendar.current

    let feedingTime =
        calendar.date(
            bySettingHour: 8,
            minute: 5,
            second: 0,
            of: Date()
        ) ?? Date()

    let walkTime =
        calendar.date(
            bySettingHour: 11,
            minute: 35,
            second: 0,
            of: Date()
        ) ?? Date()

    let medicationTime =
        calendar.date(
            bySettingHour: 14,
            minute: 5,
            second: 0,
            of: Date()
        ) ?? Date()

    let records = [

        CareActivityRecord(
            petStayID: petStayID,
            careTaskID: UUID(),
            taskType: .medication,
            completedBy: staff,
            completedAt: medicationTime,
            notes: "Carprofen 25 mg administered"
        ),

        CareActivityRecord(
            petStayID: petStayID,
            careTaskID: UUID(),
            taskType: .walk,
            completedBy: staff,
            completedAt: walkTime,
            notes: "30 minute walk completed"
        ),

        CareActivityRecord(
            petStayID: petStayID,
            careTaskID: UUID(),
            taskType: .feeding,
            completedBy: staff,
            completedAt: feedingTime,
            notes: "Ate all food"
        )
    ]

    let repository =
        PreviewCareHistoryRepository(
            records: records
        )

    let useCase =
        GetCareHistoryUseCase(
            careActivityRecordRepository:
                repository
        )

    let viewModel =
        CareHistoryViewModel(
            getCareHistoryUseCase:
                useCase
        )

    NavigationStack {
        CareHistoryView(
            petStayID: petStayID,
            viewModel: viewModel
        )
    }
}

private final class PreviewCareHistoryRepository:
    CareActivityRecordRepository {

    private var records:
        [CareActivityRecord]

    init(
        records: [CareActivityRecord]
    ) {
        self.records = records
    }

    func fetchCareActivityRecords()
        throws -> [CareActivityRecord] {

        records
    }

    func saveCareActivityRecord(
        _ record: CareActivityRecord
    ) throws {

        if let index =
            records.firstIndex(
                where: {
                    $0.id == record.id
                }
            ) {

            records[index] = record

        } else {

            records.append(
                record
            )
        }
    }

    func deleteCareActivityRecord(
        id: UUID
    ) throws {

        records.removeAll {
            $0.id == id
        }
    }
}
