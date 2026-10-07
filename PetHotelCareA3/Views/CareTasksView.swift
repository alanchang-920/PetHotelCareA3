//
//  CareTasksView.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/5.
//

import SwiftUI

struct CareTasksView: View {

    @ObservedObject var viewModel: CareTasksViewModel

    let petStayID: UUID

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
        .navigationTitle("Daily Care Tasks")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(
                placement: .topBarTrailing
            ) {
                NavigationLink {
                    AddCareTaskView(
                        viewModel: viewModel,
                        petStayID: petStayID
                    )
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            viewModel.loadTasks(
                for: petStayID
            )
        }
    }
}

private extension CareTasksView {

    @ViewBuilder
    var contentSection: some View {

        if viewModel.isLoading {
            loadingView

        } else if let errorMessage = viewModel.errorMessage {
            errorView(
                message: errorMessage
            )

        } else if viewModel.tasks.isEmpty {
            emptyState

        } else {
            tasksSection
        }
    }
}

private extension CareTasksView {

    var headerSection: some View {

        HStack {

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                Text("Care Tasks")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Daily care activities for this stay")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(spacing: 2) {

                Text("\(viewModel.tasks.count)")
                    .font(.title3)
                    .fontWeight(.bold)

                Text("Tasks")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
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
}

private extension CareTasksView {

    var tasksSection: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            HStack {

                Text("Tasks")
                    .font(.headline)

                Spacer()

                let pendingCount =
                    viewModel.tasks.filter {
                        !$0.isCompleted
                    }.count

                Text("\(pendingCount) pending")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ForEach(viewModel.tasks) { task in

                taskCard(
                    task
                )
            }
        }
    }

    func taskCard(
        _ task: CareTask
    ) -> some View {

        HStack(
            alignment: .top,
            spacing: 14
        ) {

            Image(
                systemName:
                    task.isCompleted
                    ? "checkmark.circle.fill"
                    : "circle"
            )
            .font(.title3)
            .foregroundStyle(
                task.isCompleted
                ? .primary
                : .secondary
            )

            VStack(
                alignment: .leading,
                spacing: 6
            ) {

                HStack {

                    Label(
                        taskTitle(for: task),
                        systemImage: taskIcon(for: task)
                    )
                    .font(.headline)

                    Spacer()

                    Text(
                        task.scheduledTime,
                        format: .dateTime
                            .hour()
                            .minute()
                    )
                    .font(.subheadline)
                    .fontWeight(.medium)
                }

                if !task.instructions.isEmpty {

                    Text(task.instructions)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(
                    task.isCompleted
                    ? "Completed"
                    : "Pending"
                )
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(
                    task.isCompleted
                    ? .secondary
                    : .primary
                )
                
                if !task.isCompleted {
                    Button {
                        completeTask(task)
                    } label: {
                        Label(
                            "Mark as Completed",
                            systemImage: "checkmark.circle"
                        )
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 4)
                }
            }
        }
        .padding()
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(
            Color(.secondarySystemBackground)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16
            )
        )
    }
}

private extension CareTasksView {

    var loadingView: some View {

        VStack(spacing: 12) {

            ProgressView()

            Text("Loading care tasks...")
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
                systemName: "checklist"
            )
            .font(.largeTitle)

            Text("No Care Tasks")
                .font(.headline)

            Text(
                "There are no care tasks for this stay."
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 180
        )
    }

    func errorView(
        message: String
    ) -> some View {

        VStack(spacing: 12) {

            Image(
                systemName:
                    "exclamationmark.triangle"
            )
            .font(.title)

            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 180
        )
    }
}

private extension CareTasksView {

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

    func taskIcon(
        for task: CareTask
    ) -> String {

        switch task.type {

        case .feeding:
            return "fork.knife"

        case .walk:
            return "figure.walk"

        case .medication:
            return "pills"
        }
    }
}

#Preview("Care Tasks") {

    let petStayID = UUID()

    let calendar = Calendar.current

    let feedingTime =
        calendar.date(
            bySettingHour: 8,
            minute: 0,
            second: 0,
            of: Date()
        ) ?? Date()

    let walkTime =
        calendar.date(
            bySettingHour: 11,
            minute: 30,
            second: 0,
            of: Date()
        ) ?? Date()

    let medicationTime =
        calendar.date(
            bySettingHour: 14,
            minute: 0,
            second: 0,
            of: Date()
        ) ?? Date()

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

    let careTaskRepository =
        PreviewCareTaskRepository(
            tasks: tasks
        )

    let activityRepository =
        PreviewCareActivityRecordRepository()

    let manageUseCase =
        ManageCareTasksUseCase(
            careTaskRepository:
                careTaskRepository
        )

    let completeUseCase =
        CompleteCareTaskUseCase(
            careTaskRepository:
                careTaskRepository,
            careActivityRecordRepository:
                activityRepository
        )

    let viewModel =
        CareTasksViewModel(
            manageCareTasksUseCase:
                manageUseCase,
            completeCareTaskUseCase:
                completeUseCase
        )

    NavigationStack {

        CareTasksView(
            viewModel: viewModel,
            petStayID: petStayID
        )
    }
}

private final class PreviewCareTaskRepository:
    CareTaskRepository {

    private var tasks: [CareTask]

    init(
        tasks: [CareTask]
    ) {
        self.tasks = tasks
    }

    func fetchCareTasks()
        throws -> [CareTask] {

        tasks
    }

    func saveCareTask(
        _ careTask: CareTask
    ) throws {

        tasks.append(
            careTask
        )
    }

    func updateCareTask(
        _ careTask: CareTask
    ) throws {

        guard let index =
                tasks.firstIndex(
                    where: {
                        $0.id == careTask.id
                    }
                )
        else {
            return
        }

        tasks[index] = careTask
    }

    func deleteCareTask(
        id: UUID
    ) throws {

        tasks.removeAll {
            $0.id == id
        }
    }
}

private final class PreviewCareActivityRecordRepository:
    CareActivityRecordRepository {

    private var records:
        [CareActivityRecord] = []

    func fetchCareActivityRecords()
        throws -> [CareActivityRecord] {

        records
    }

    func saveCareActivityRecord(
        _ record: CareActivityRecord
    ) throws {

        records.append(
            record
        )
    }

    func deleteCareActivityRecord(
        id: UUID
    ) throws {

        records.removeAll {
            $0.id == id
        }
    }
}

private extension CareTasksView {

    func completeTask(
        _ task: CareTask
    ) {
        let staff = StaffMember(
            name: "Staff"
        )

        viewModel.completeTask(
            task,
            completedBy: staff,
            notes: ""
        )
    }
}
