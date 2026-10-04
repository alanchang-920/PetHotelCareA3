//
//  ManageCareTasksUseCase.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/4.
//

import Foundation

final class ManageCareTasksUseCase {

    private let careTaskRepository: CareTaskRepository

    init(careTaskRepository: CareTaskRepository) {
        self.careTaskRepository = careTaskRepository
    }

    func getTasks(for petStayID: UUID) throws -> [CareTask] {
        let tasks = try careTaskRepository.fetchCareTasks()

        return tasks
            .filter {
                $0.petStayID == petStayID
            }
            .sorted {
                $0.scheduledTime < $1.scheduledTime
            }
    }

    @discardableResult
    func createTask(
        petStayID: UUID,
        type: CareTaskType,
        scheduledTime: Date,
        instructions: String
    ) throws -> CareTask {

        let task = CareTask(
            petStayID: petStayID,
            type: type,
            scheduledTime: scheduledTime,
            instructions: instructions,
            isCompleted: false
        )

        try careTaskRepository.saveCareTask(task)

        return task
    }

    func deleteTask(id: UUID) throws {
        try careTaskRepository.deleteCareTask(id: id)
    }
}
