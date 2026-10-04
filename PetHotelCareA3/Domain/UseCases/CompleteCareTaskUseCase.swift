//
//  CompleteCareTaskUseCase.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/4.
//

import Foundation

final class CompleteCareTaskUseCase {

    private let careTaskRepository: CareTaskRepository
    private let careActivityRecordRepository: CareActivityRecordRepository

    init(
        careTaskRepository: CareTaskRepository,
        careActivityRecordRepository: CareActivityRecordRepository
    ) {
        self.careTaskRepository = careTaskRepository
        self.careActivityRecordRepository = careActivityRecordRepository
    }

    func execute(
        careTaskID: UUID,
        completedBy staffMember: StaffMember,
        notes: String,
        completedAt: Date = Date()
    ) throws {

        let tasks = try careTaskRepository.fetchCareTasks()

        guard var task = tasks.first(where: {
            $0.id == careTaskID
        }) else {
            return
        }

        guard task.isCompleted == false else {
            return
        }

        task.isCompleted = true

        try careTaskRepository.updateCareTask(task)

        let record = CareActivityRecord(
            petStayID: task.petStayID,
            careTaskID: task.id,
            taskType: task.type,
            completedBy: staffMember,
            completedAt: completedAt,
            notes: notes
        )

        try careActivityRecordRepository.saveCareActivityRecord(record)
    }
}
