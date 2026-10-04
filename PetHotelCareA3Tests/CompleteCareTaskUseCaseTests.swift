//
//  CompleteCareTaskUseCaseTests.swift
//  PetHotelCareA3Tests
//
//  Created by Chang Chia ming on 2026/10/4.
//

import Foundation
import Testing
@testable import PetHotelCareA3


private final class MockCompleteCareTaskRepository: CareTaskRepository {

    var tasks: [CareTask] = []

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
        tasks.removeAll { $0.id == id }
    }
}


private final class MockCareActivityRecordRepository:
    CareActivityRecordRepository {

    var records: [CareActivityRecord] = []

    func fetchCareActivityRecords() throws -> [CareActivityRecord] {
        records
    }

    func saveCareActivityRecord(
        _ record: CareActivityRecord
    ) throws {
        records.append(record)
    }

    func deleteCareActivityRecord(id: UUID) throws {
        records.removeAll { $0.id == id }
    }
}


struct CompleteCareTaskUseCaseTests {

    @Test
    func completesIncompleteCareTask() throws {

        let petStayID = UUID()

        let task = CareTask(
            petStayID: petStayID,
            type: .feeding,
            scheduledTime: Date(),
            instructions: "Feed breakfast",
            isCompleted: false
        )

        let taskRepository = MockCompleteCareTaskRepository()
        taskRepository.tasks = [task]

        let activityRepository =
            MockCareActivityRecordRepository()

        let useCase = CompleteCareTaskUseCase(
            careTaskRepository: taskRepository,
            careActivityRecordRepository: activityRepository
        )

        let staff = StaffMember(
            name: "Test Staff"
        )

        try useCase.execute(
            careTaskID: task.id,
            completedBy: staff,
            notes: "Task completed"
        )

        #expect(taskRepository.tasks.count == 1)
        #expect(taskRepository.tasks.first?.isCompleted == true)
    }


    @Test
    func createsActivityRecordWhenTaskCompleted() throws {

        let petStayID = UUID()

        let task = CareTask(
            petStayID: petStayID,
            type: .feeding,
            scheduledTime: Date(),
            instructions: "Feed breakfast",
            isCompleted: false
        )

        let taskRepository = MockCompleteCareTaskRepository()
        taskRepository.tasks = [task]

        let activityRepository =
            MockCareActivityRecordRepository()

        let useCase = CompleteCareTaskUseCase(
            careTaskRepository: taskRepository,
            careActivityRecordRepository: activityRepository
        )

        let staff = StaffMember(
            name: "Test Staff"
        )

        let completionDate = Date()

        try useCase.execute(
            careTaskID: task.id,
            completedBy: staff,
            notes: "Ate all food",
            completedAt: completionDate
        )

        #expect(activityRepository.records.count == 1)

        let record = activityRepository.records.first

        #expect(record?.careTaskID == task.id)
        #expect(record?.petStayID == petStayID)
        #expect(record?.taskType == .feeding)
        #expect(record?.completedBy.id == staff.id)
        #expect(record?.completedBy.name == staff.name)
        #expect(record?.completedAt == completionDate)
        #expect(record?.notes == "Ate all food")
    }


    @Test
    func doesNotCreateDuplicateRecordForCompletedTask() throws {

        let task = CareTask(
            petStayID: UUID(),
            type: .walk,
            scheduledTime: Date(),
            instructions: "Morning walk",
            isCompleted: true
        )

        let taskRepository = MockCompleteCareTaskRepository()
        taskRepository.tasks = [task]

        let activityRepository =
            MockCareActivityRecordRepository()

        let useCase = CompleteCareTaskUseCase(
            careTaskRepository: taskRepository,
            careActivityRecordRepository: activityRepository
        )

        let staff = StaffMember(
            name: "Test Staff"
        )

        try useCase.execute(
            careTaskID: task.id,
            completedBy: staff,
            notes: "Completed"
        )

        #expect(taskRepository.tasks.count == 1)
        #expect(taskRepository.tasks.first?.isCompleted == true)

        #expect(activityRepository.records.isEmpty)
    }
    
    @Test
    func doesNothingWhenCareTaskDoesNotExist() throws {

        let taskRepository = MockCompleteCareTaskRepository()

        let activityRepository =
            MockCareActivityRecordRepository()

        let useCase = CompleteCareTaskUseCase(
            careTaskRepository: taskRepository,
            careActivityRecordRepository: activityRepository
        )

        let staff = StaffMember(
            name: "Test Staff"
        )

        try useCase.execute(
            careTaskID: UUID(),
            completedBy: staff,
            notes: "Completed"
        )

        #expect(taskRepository.tasks.isEmpty)
        #expect(activityRepository.records.isEmpty)
    }
}
