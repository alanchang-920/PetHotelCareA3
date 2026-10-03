//
//  CoreDataMedicationScheduleRepositoryTests.swift
//  PetHotelCareA3Tests
//
//  Created by Chang Chia ming on 2026/10/3.
//

import Testing
import CoreData
@testable import PetHotelCareA3

@MainActor
struct CoreDataMedicationScheduleRepositoryTests {

    private func makeRepository() -> CoreDataMedicationScheduleRepository {
        let persistenceController = PersistenceController(inMemory: true)

        return CoreDataMedicationScheduleRepository(
            context: persistenceController.container.viewContext
        )
    }

    private func makeMedicationSchedule() -> MedicationSchedule {
        MedicationSchedule(
            petStayID: UUID(),
            medicationName: "Carprofen",
            dosage: "25 mg",
            scheduledTime: Date(),
            minimumIntervalHours: 12
        )
    }

    @Test
    func saveAndFetchMedicationSchedule() throws {
   
        let repository = makeRepository()
        let schedule = makeMedicationSchedule()

        try repository.saveMedicationSchedule(schedule)

        let schedules = try repository.fetchMedicationSchedules()

        #expect(schedules.count == 1)
        #expect(schedules.first?.id == schedule.id)
        #expect(schedules.first?.petStayID == schedule.petStayID)
        #expect(schedules.first?.medicationName == "Carprofen")
        #expect(schedules.first?.dosage == "25 mg")
        #expect(schedules.first?.minimumIntervalHours == 12)
    }

    @Test
    func deleteMedicationSchedule() throws {
       
        let repository = makeRepository()
        let schedule = makeMedicationSchedule()

        try repository.saveMedicationSchedule(schedule)

        var schedules = try repository.fetchMedicationSchedules()
        #expect(schedules.count == 1)

        try repository.deleteMedicationSchedule(id: schedule.id)

        schedules = try repository.fetchMedicationSchedules()
        #expect(schedules.isEmpty)
    }
}
