//
//  CoreDataCareActivityRecordRepositoryTests.swift
//  PetHotelCareA3Tests
//
//  Created by Chang Chia ming on 2026/10/4.
//

import Testing
import CoreData
@testable import PetHotelCareA3

@MainActor
struct CoreDataCareActivityRecordRepositoryTests {

    private func makeRepository() -> CoreDataCareActivityRecordRepository {
        let persistenceController = PersistenceController(inMemory: true)

        return CoreDataCareActivityRecordRepository(
            context: persistenceController.container.viewContext
        )
    }

    @Test
    func saveAndFetchCareActivityRecord() throws {
        
        let repository = makeRepository()

        let petStayID = UUID()
        let careTaskID = UUID()

        let staff = StaffMember(
            name: "Alex"
        )

        let record = CareActivityRecord(
            petStayID: petStayID,
            careTaskID: careTaskID,
            taskType: .feeding,
            completedBy: staff,
            completedAt: Date(),
            notes: "Fed according to instructions"
        )

        
        try repository.saveCareActivityRecord(record)

        let records = try repository.fetchCareActivityRecords()

        
        #expect(records.count == 1)
        #expect(records.first?.id == record.id)
        #expect(records.first?.petStayID == petStayID)
        #expect(records.first?.careTaskID == careTaskID)
        #expect(records.first?.taskType == .feeding)
        #expect(records.first?.completedBy.id == staff.id)
        #expect(records.first?.completedBy.name == "Alex")
        #expect(records.first?.notes == "Fed according to instructions")
    }
    
    @Test
    func deleteCareActivityRecord() throws {
        // Given
        let repository = makeRepository()

        let staff = StaffMember(
            name: "Alex"
        )

        let record = CareActivityRecord(
            petStayID: UUID(),
            careTaskID: UUID(),
            taskType: .feeding,
            completedBy: staff,
            completedAt: Date(),
            notes: "Fed according to instructions"
        )

        try repository.saveCareActivityRecord(record)

        var records = try repository.fetchCareActivityRecords()
        #expect(records.count == 1)

        // When
        try repository.deleteCareActivityRecord(id: record.id)

        // Then
        records = try repository.fetchCareActivityRecords()
        #expect(records.isEmpty)
    }
}
