//
//  CoreDataCareTaskRepositoryTests.swift
//  PetHotelCareA3Tests
//
//  Created by Chang Chia ming on 2026/10/3.
//

import XCTest
import CoreData
@testable import PetHotelCareA3

final class CoreDataCareTaskRepositoryTests: XCTestCase {

    private var persistenceController: PersistenceController!
    private var repository: CoreDataCareTaskRepository!

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)

        repository = CoreDataCareTaskRepository(
            context: persistenceController.container.viewContext
        )
    }

    override func tearDownWithError() throws {
        repository = nil
        persistenceController = nil
    }
    
    func testSaveAndFetchCareTask() throws {
            let task = CareTask(
                petStayID: UUID(),
                type: .feeding,
                scheduledTime: Date(),
                instructions: "Feed 1 cup of dry food",
                isCompleted: false
            )

            try repository.saveCareTask(task)

            let tasks = try repository.fetchCareTasks()

            XCTAssertEqual(tasks.count, 1)

            let fetchedTask = try XCTUnwrap(tasks.first)

            XCTAssertEqual(fetchedTask.id, task.id)
            XCTAssertEqual(fetchedTask.petStayID, task.petStayID)
            XCTAssertEqual(fetchedTask.type, .feeding)
            XCTAssertEqual(fetchedTask.scheduledTime, task.scheduledTime)
            XCTAssertEqual(
                fetchedTask.instructions,
                "Feed 1 cup of dry food"
            )
            XCTAssertFalse(fetchedTask.isCompleted)
        }
    
    func testDeleteCareTask() throws {
            let task = CareTask(
                petStayID: UUID(),
                type: .walk,
                scheduledTime: Date(),
                instructions: "Walk for 30 minutes",
                isCompleted: false
            )

            try repository.saveCareTask(task)

            var tasks = try repository.fetchCareTasks()
            XCTAssertEqual(tasks.count, 1)

            try repository.deleteCareTask(id: task.id)

            tasks = try repository.fetchCareTasks()
            XCTAssertEqual(tasks.count, 0)
        }
}
