//
//  GetCareHistoryUseCaseTests.swift
//  PetHotelCareA3Tests
//
//  Created by Chang Chia ming on 2026/10/4.
//

import Foundation
import Testing
@testable import PetHotelCareA3


private final class MockCareHistoryRepository:
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


struct GetCareHistoryUseCaseTests {

    @Test
    func returnsCareHistoryForPetStaySortedNewestFirst() throws {

        let repository = MockCareHistoryRepository()

        let useCase = GetCareHistoryUseCase(
            careActivityRecordRepository: repository
        )

        let targetStayID = UUID()
        let otherStayID = UUID()

        let staff = StaffMember(
            name: "Test Staff"
        )

        let calendar = Calendar.current

        let date = calendar.date(
            from: DateComponents(
                year: 2026,
                month: 10,
                day: 4
            )
        )!

        let morningRecord = CareActivityRecord(
            petStayID: targetStayID,
            careTaskID: UUID(),
            taskType: .feeding,
            completedBy: staff,
            completedAt: calendar.date(
                bySettingHour: 8,
                minute: 0,
                second: 0,
                of: date
            )!,
            notes: "Breakfast completed"
        )

        let afternoonRecord = CareActivityRecord(
            petStayID: targetStayID,
            careTaskID: UUID(),
            taskType: .walk,
            completedBy: staff,
            completedAt: calendar.date(
                bySettingHour: 15,
                minute: 0,
                second: 0,
                of: date
            )!,
            notes: "Afternoon walk completed"
        )

        let otherStayRecord = CareActivityRecord(
            petStayID: otherStayID,
            careTaskID: UUID(),
            taskType: .feeding,
            completedBy: staff,
            completedAt: calendar.date(
                bySettingHour: 20,
                minute: 0,
                second: 0,
                of: date
            )!,
            notes: "Other pet activity"
        )

        repository.records = [
            morningRecord,
            otherStayRecord,
            afternoonRecord
        ]

        let result = try useCase.execute(
            for: targetStayID
        )

        #expect(result.count == 2)

        #expect(result[0].id == afternoonRecord.id)
        #expect(result[1].id == morningRecord.id)

        #expect(
            result.allSatisfy {
                $0.petStayID == targetStayID
            }
        )
    }


    @Test
    func returnsEmptyHistoryWhenNoRecordsExist() throws {

        let repository = MockCareHistoryRepository()

        let useCase = GetCareHistoryUseCase(
            careActivityRecordRepository: repository
        )

        let result = try useCase.execute(
            for: UUID()
        )

        #expect(result.isEmpty)
    }


    @Test
    func returnsEmptyHistoryWhenPetStayHasNoRecords() throws {

        let repository = MockCareHistoryRepository()

        let useCase = GetCareHistoryUseCase(
            careActivityRecordRepository: repository
        )

        let targetStayID = UUID()
        let otherStayID = UUID()

        let staff = StaffMember(
            name: "Test Staff"
        )

        let otherStayRecord = CareActivityRecord(
            petStayID: otherStayID,
            careTaskID: UUID(),
            taskType: .feeding,
            completedBy: staff,
            completedAt: Date(),
            notes: "Other pet activity"
        )

        repository.records = [
            otherStayRecord
        ]

        let result = try useCase.execute(
            for: targetStayID
        )

        #expect(result.isEmpty)
    }
}
