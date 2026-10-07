//
//  CareTasksViewModel.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/5.
//

import Foundation
import Combine

@MainActor
final class CareTasksViewModel: ObservableObject {

    @Published private(set) var tasks: [CareTask] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let manageCareTasksUseCase:
        ManageCareTasksUseCase

    private let completeCareTaskUseCase:
        CompleteCareTaskUseCase

    init(
        manageCareTasksUseCase: ManageCareTasksUseCase,
        completeCareTaskUseCase: CompleteCareTaskUseCase
    ) {
        self.manageCareTasksUseCase =
            manageCareTasksUseCase

        self.completeCareTaskUseCase =
            completeCareTaskUseCase
    }

    func loadTasks(
        for petStayID: UUID
    ) {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            tasks =
                try manageCareTasksUseCase
                    .getTasks(
                        for: petStayID
                    )

            WidgetDataService.shared
                .updateWidget(
                    with: tasks
                )

        } catch {
            tasks = []

            errorMessage =
                "Unable to load care tasks."
        }
    }

    func createTask(
        petStayID: UUID,
        type: CareTaskType,
        scheduledTime: Date,
        instructions: String
    ) {
        errorMessage = nil

        do {
            try manageCareTasksUseCase
                .createTask(
                    petStayID: petStayID,
                    type: type,
                    scheduledTime: scheduledTime,
                    instructions: instructions
                )

            loadTasks(
                for: petStayID
            )

        } catch {
            errorMessage =
                "Unable to create this care task. Please check the task details and try again."
        }
    }

    func completeTask(
        _ task: CareTask,
        completedBy staff: StaffMember,
        notes: String
    ) {
        errorMessage = nil

        do {
            try completeCareTaskUseCase
                .execute(
                    careTaskID: task.id,
                    completedBy: staff,
                    notes: notes
                )

            loadTasks(
                for: task.petStayID
            )

        } catch {
            errorMessage =
                "Unable to complete this care task. Please try again."
        }
    }

    func deleteTask(
        _ task: CareTask
    ) {
        errorMessage = nil

        do {
            try manageCareTasksUseCase
                .deleteTask(
                    id: task.id
                )

            loadTasks(
                for: task.petStayID
            )

        } catch {
            errorMessage =
                "Unable to delete this care task. Please try again."
        }
    }
}
