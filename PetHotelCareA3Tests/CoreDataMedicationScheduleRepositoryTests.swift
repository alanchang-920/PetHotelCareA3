//
//  CoreDataMedicationScheduleRepositoryTests.swift
//  PetHotelCareA3Tests
//
//  Created by Chang Chia ming on 2026/10/3.
//

import XCTest
import CoreData
@testable import PetHotelCareA3

final class CoreDataMedicationScheduleRepositoryTests: XCTestCase {

    private var persistenceController: PersistenceController!
    private var repository: CoreDataMedicationScheduleRepository!

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)

        repository = CoreDataMedicationScheduleRepository(
            context: persistenceController.container.viewContext
        )
    }

    override func tearDownWithError() throws {
        repository = nil
        persistenceController = nil
    }
    
    func testSaveAndFetchMedicationSchedule() throws {
        let petStayID = UUID()

        let schedule = MedicationSchedule(
            petStayID: petStayID,
            medicationName: "Carprofen",
            dosage: "25 mg",
            scheduledTime: Date(),
            minimumIntervalHours: 12
        )

        try repository.saveMedicationSchedule(schedule)

        let schedules = try repository.fetchMedicationSchedules()

        XCTAssertEqual(schedules.count, 1)
        XCTAssertEqual(schedules.first?.id, schedule.id)
        XCTAssertEqual(schedules.first?.petStayID, petStayID)
        XCTAssertEqual(schedules.first?.medicationName, "Carprofen")
        XCTAssertEqual(schedules.first?.dosage, "25 mg")
        XCTAssertEqual(schedules.first?.minimumIntervalHours, 12)
    }
    
    func testDeleteMedicationSchedule() throws {
        let schedule = MedicationSchedule(
            petStayID: UUID(),
            medicationName: "Carprofen",
            dosage: "25 mg",
            scheduledTime: Date(),
            minimumIntervalHours: 12
        )

        // Save the schedule first
        try repository.saveMedicationSchedule(schedule)

        // Make sure the schedule was saved
        var schedules = try repository.fetchMedicationSchedules()
        XCTAssertEqual(schedules.count, 1)

        // Delete the schedule
        try repository.deleteMedicationSchedule(id: schedule.id)

        // Fetch again and make sure it is gone
        schedules = try repository.fetchMedicationSchedules()
        XCTAssertEqual(schedules.count, 0)
    }
}
