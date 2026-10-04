//
//  ManageCareTasksUseCaseTests.swift
//  PetHotelCareA3Tests
//
//  Created by Chang Chia ming on 2026/10/4.
//

import Foundation
import Testing
@testable import PetHotelCareA3

private final class MockManageCareTaskRepository: CareTaskRepository {

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

struct ManageCareTasksUseCaseTests {
    
    @Test
    func getsTasksForPetStaySortedByTime() throws {

        let repository = MockManageCareTaskRepository()
        let useCase = ManageCareTasksUseCase(
            careTaskRepository: repository
        )

        let targetStayID = UUID()
        let otherStayID = UUID()

        let calendar = Calendar.current

        let date = calendar.date(
            from: DateComponents(
                year: 2026,
                month: 10,
                day: 4
            )
        )!

        let afternoonTask = CareTask(
            petStayID: targetStayID,
            type: .walk,
            scheduledTime: calendar.date(
                bySettingHour: 15,
                minute: 0,
                second: 0,
                of: date
            )!,
            instructions: "Afternoon walk",
            isCompleted: false
        )

        let morningTask = CareTask(
            petStayID: targetStayID,
            type: .feeding,
            scheduledTime: calendar.date(
                bySettingHour: 9,
                minute: 0,
                second: 0,
                of: date
            )!,
            instructions: "Morning feeding",
            isCompleted: false
        )

        let otherStayTask = CareTask(
            petStayID: otherStayID,
            type: .feeding,
            scheduledTime: calendar.date(
                bySettingHour: 8,
                minute: 0,
                second: 0,
                of: date
            )!,
            instructions: "Other pet feeding",
            isCompleted: false
        )

        repository.tasks = [
            afternoonTask,
            otherStayTask,
            morningTask
        ]

        let result = try useCase.getTasks(
            for: targetStayID
        )

        #expect(result.count == 2)

        #expect(result[0].id == morningTask.id)
        #expect(result[1].id == afternoonTask.id)

        #expect(result.allSatisfy {
            $0.petStayID == targetStayID
        })
    }
    
    @Test
    func createsNewCareTaskAsIncomplete() throws {
   
        let repository = MockManageCareTaskRepository()
        let useCase = ManageCareTasksUseCase(
            careTaskRepository: repository
        )

        let petStayID = UUID()

        let scheduledTime = Calendar.current.date(
            from: DateComponents(
                year: 2026,
                month: 10,
                day: 4,
                hour: 15
            )
        )!

        let result = try useCase.createTask(
            petStayID: petStayID,
            type: .walk,
            scheduledTime: scheduledTime,
            instructions: "30 minute outdoor walk"
        )

        #expect(repository.tasks.count == 1)

        #expect(result.petStayID == petStayID)
        #expect(result.type == .walk)
        #expect(result.scheduledTime == scheduledTime)
        #expect(result.instructions == "30 minute outdoor walk")

        #expect(result.isCompleted == false)

        #expect(repository.tasks.first?.id == result.id)
    }
    
    @Test
    func deletesCareTask() throws {
     
        let repository = MockManageCareTaskRepository()
        let useCase = ManageCareTasksUseCase(
            careTaskRepository: repository
        )

        let taskToDelete = CareTask(
            petStayID: UUID(),
            type: .feeding,
            scheduledTime: Date(),
            instructions: "Morning feeding",
            isCompleted: false
        )

        let taskToKeep = CareTask(
            petStayID: UUID(),
            type: .walk,
            scheduledTime: Date(),
            instructions: "Afternoon walk",
            isCompleted: false
        )

        repository.tasks = [
            taskToDelete,
            taskToKeep
        ]

        try useCase.deleteTask(
            id: taskToDelete.id
        )

        #expect(repository.tasks.count == 1)

        #expect(
            repository.tasks.first?.id == taskToKeep.id
        )

        #expect(
            repository.tasks.contains {
                $0.id == taskToDelete.id
            } == false
        )
    }

}
