//
//  CoreDataCareTaskRepositoryTests.swift
//  PetHotelCareA3Tests
//
//  Created by Chang Chia ming on 2026/10/3.
//

import Testing
import CoreData
@testable import PetHotelCareA3

@MainActor
struct CoreDataCareTaskRepositoryTests {

    private func makeRepository() -> CoreDataCareTaskRepository {
        let persistenceController = PersistenceController(inMemory: true)

        return CoreDataCareTaskRepository(
            context: persistenceController.container.viewContext
        )
    }

    private func makeCareTask() -> CareTask {
        CareTask(
            petStayID: UUID(),
            type: .feeding,
            scheduledTime: Date(),
            instructions: "Feed according to instructions",
            isCompleted: false
        )
    }

    @Test
    func saveAndFetchCareTask() throws {
        
        let repository = makeRepository()
        let task = makeCareTask()

        try repository.saveCareTask(task)

        let tasks = try repository.fetchCareTasks()

        #expect(tasks.count == 1)
        #expect(tasks.first?.id == task.id)
        #expect(tasks.first?.petStayID == task.petStayID)
        #expect(tasks.first?.type == .feeding)
        #expect(tasks.first?.instructions == "Feed according to instructions")
        #expect(tasks.first?.isCompleted == false)
    }

    @Test
    func deleteCareTask() throws {
        
        let repository = makeRepository()
        let task = makeCareTask()

        try repository.saveCareTask(task)

        var tasks = try repository.fetchCareTasks()
        #expect(tasks.count == 1)

        try repository.deleteCareTask(id: task.id)

        tasks = try repository.fetchCareTasks()
        #expect(tasks.isEmpty)
    }
}
