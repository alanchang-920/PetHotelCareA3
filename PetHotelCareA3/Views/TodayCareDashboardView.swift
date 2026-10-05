//
//  TodayCareDashboardView.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/5.
//

import SwiftUI

struct TodayCareDashboardView: View {

    @ObservedObject var viewModel: TodayCareDashboardViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                headerSection

                overviewSection

                todaysTasksSection
            }
            .padding()
        }
        .navigationTitle("Today's Care")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadTasks()
        }
    }
}

private extension TodayCareDashboardView {

    var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {

            Text("Care Dashboard")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(
                Date(),
                format: .dateTime
                    .weekday(.wide)
                    .month(.wide)
                    .day()
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }


    var overviewSection: some View {
        HStack(spacing: 12) {

            overviewCard(
                title: "Tasks",
                value: "\(viewModel.tasks.count)",
                systemImage: "checklist"
            )

            overviewCard(
                title: "Completed",
                value: "\(completedTaskCount)",
                systemImage: "checkmark.circle"
            )

            overviewCard(
                title: "Pending",
                value: "\(pendingTaskCount)",
                systemImage: "clock"
            )
        }
    }


    var todaysTasksSection: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {

                Text("Today's Tasks")
                    .font(.title2)
                    .fontWeight(.semibold)

                Spacer()

                Text("\(pendingTaskCount) pending")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if viewModel.isLoading {

                ProgressView()
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 120
                    )

            } else if let errorMessage = viewModel.errorMessage {

                errorView(message: errorMessage)

            } else if viewModel.tasks.isEmpty {

                emptyTasksView

            } else {

                LazyVStack(spacing: 12) {
                    ForEach(viewModel.tasks) { task in
                        taskCard(task)
                    }
                }
            }
        }
    }
}

private extension TodayCareDashboardView {

    var completedTaskCount: Int {
        viewModel.tasks.filter {
            $0.isCompleted
        }.count
    }

    var pendingTaskCount: Int {
        viewModel.tasks.filter {
            !$0.isCompleted
        }.count
    }
}


private extension TodayCareDashboardView {

    func overviewCard(
        title: String,
        value: String,
        systemImage: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 10) {

            Image(systemName: systemImage)
                .font(.title3)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding()
        .background(
            Color(.secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }


    func taskCard(
        _ task: CareTask
    ) -> some View {

        HStack(spacing: 14) {

            Image(
                systemName: task.isCompleted
                    ? "checkmark.circle.fill"
                    : "circle"
            )
            .font(.title2)

            VStack(alignment: .leading, spacing: 5) {

                Text(taskTitle(for: task))
                    .font(.headline)

                Text(task.instructions)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 5) {

                Text(
                    task.scheduledTime,
                    format: .dateTime
                        .hour()
                        .minute()
                )
                .font(.subheadline)
                .fontWeight(.medium)

                Text(
                    task.isCompleted
                        ? "Completed"
                        : "Pending"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(
            Color(.secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }


    var emptyTasksView: some View {
        VStack(spacing: 12) {

            Image(systemName: "checkmark.circle")
                .font(.largeTitle)

            Text("No Care Tasks Today")
                .font(.headline)

            Text("There are no care tasks scheduled for today.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 160
        )
    }


    func errorView(
        message: String
    ) -> some View {

        VStack(spacing: 10) {

            Image(
                systemName: "exclamationmark.triangle"
            )
            .font(.title)

            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 140
        )
    }


    func taskTitle(
        for task: CareTask
    ) -> String {

        switch task.type {

        case .feeding:
            return "Feeding"

        case .walk:
            return "Walk"

        case .medication:
            return "Medication"
        }
    }
}

private final class PreviewCareTaskRepository: CareTaskRepository {

    private var tasks: [CareTask]

    init(tasks: [CareTask]) {
        self.tasks = tasks
    }

    func fetchCareTasks() throws -> [CareTask] {
        tasks
    }

    func saveCareTask(_ careTask: CareTask) throws {
        tasks.append(careTask)
    }

    func updateCareTask(_ careTask: CareTask) throws {
        guard let index = tasks.firstIndex(where: {
            $0.id == careTask.id
        }) else {
            return
        }

        tasks[index] = careTask
    }

    func deleteCareTask(id: UUID) throws {
        tasks.removeAll {
            $0.id == id
        }
    }
}

#Preview("Today's Care Dashboard") {

    let petStayID = UUID()
    let calendar = Calendar.current
    let now = Date()

    let feedingTime =
        calendar.date(
            bySettingHour: 8,
            minute: 0,
            second: 0,
            of: now
        ) ?? now

    let walkTime =
        calendar.date(
            bySettingHour: 11,
            minute: 30,
            second: 0,
            of: now
        ) ?? now

    let medicationTime =
        calendar.date(
            bySettingHour: 14,
            minute: 0,
            second: 0,
            of: now
        ) ?? now

    let tasks = [
        CareTask(
            petStayID: petStayID,
            type: .feeding,
            scheduledTime: feedingTime,
            instructions: "1 cup of dry food",
            isCompleted: false
        ),

        CareTask(
            petStayID: petStayID,
            type: .walk,
            scheduledTime: walkTime,
            instructions: "30 minute walk",
            isCompleted: true
        ),

        CareTask(
            petStayID: petStayID,
            type: .medication,
            scheduledTime: medicationTime,
            instructions: "Carprofen 25 mg",
            isCompleted: false
        )
    ]

    let repository =
        PreviewCareTaskRepository(
            tasks: tasks
        )

    let useCase =
        GetTodaysCareTasksUseCase(
            careTaskRepository: repository
        )

    let viewModel =
        TodayCareDashboardViewModel(
            getTodaysCareTasksUseCase: useCase
        )

    return NavigationStack {
        TodayCareDashboardView(
            viewModel: viewModel
        )
    }
}
