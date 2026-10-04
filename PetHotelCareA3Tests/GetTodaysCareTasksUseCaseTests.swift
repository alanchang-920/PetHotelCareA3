//
//  GetTodaysCareTasksUseCaseTests.swift
//  PetHotelCareA3Tests
//
//  Created by Chang Chia ming on 2026/10/4.
//

import Foundation
import Testing
@testable import PetHotelCareA3

private final class MockCareTaskRepository: CareTaskRepository {

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

struct GetTodaysCareTasksUseCaseTests {

    @Test
    func returnsOnlyTasksForSelectedDate() throws {
        
        let repository = MockCareTaskRepository()
        let useCase = GetTodaysCareTasksUseCase(
            careTaskRepository: repository
        )

        let calendar = Calendar.current

        let selectedDate = calendar.date(
            from: DateComponents(
                year: 2026,
                month: 10,
                day: 4,
                hour: 12
            )
        )!

        let morningTask = CareTask(
            petStayID: UUID(),
            type: .feeding,
            scheduledTime: calendar.date(
                bySettingHour: 9,
                minute: 0,
                second: 0,
                of: selectedDate
            )!,
            instructions: "Morning feeding",
            isCompleted: false
        )

        let tomorrowTask = CareTask(
            petStayID: UUID(),
            type: .walk,
            scheduledTime: calendar.date(
                byAdding: .day,
                value: 1,
                to: selectedDate
            )!,
            instructions: "Tomorrow walk",
            isCompleted: false
        )

        repository.tasks = [
            morningTask,
            tomorrowTask
        ]

        let result = try useCase.execute(for: selectedDate)

        #expect(result.count == 1)
        #expect(result.first?.id == morningTask.id)
    }

    @Test
    func sortsTasksByScheduledTime() throws {
        
        let repository = MockCareTaskRepository()
        let useCase = GetTodaysCareTasksUseCase(
            careTaskRepository: repository
        )

        let calendar = Calendar.current

        let selectedDate = calendar.date(
            from: DateComponents(
                year: 2026,
                month: 10,
                day: 4
            )
        )!

        let afternoonTask = CareTask(
            petStayID: UUID(),
            type: .walk,
            scheduledTime: calendar.date(
                bySettingHour: 15,
                minute: 0,
                second: 0,
                of: selectedDate
            )!,
            instructions: "Afternoon walk",
            isCompleted: false
        )

        let morningTask = CareTask(
            petStayID: UUID(),
            type: .feeding,
            scheduledTime: calendar.date(
                bySettingHour: 9,
                minute: 0,
                second: 0,
                of: selectedDate
            )!,
            instructions: "Morning feeding",
            isCompleted: false
        )

        repository.tasks = [
            afternoonTask,
            morningTask
        ]

        let result = try useCase.execute(for: selectedDate)

        #expect(result.count == 2)
        #expect(result[0].id == morningTask.id)
        #expect(result[1].id == afternoonTask.id)
    }
}
