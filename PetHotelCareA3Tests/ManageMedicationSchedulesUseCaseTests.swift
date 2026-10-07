//
//  ManageMedicationSchedulesUseCaseTests.swift
//  PetHotelCareA3Tests
//
//  Created by Chang Chia ming on 2026/10/4.
//

import Foundation
import Testing
@testable import PetHotelCareA3

private final class MockManageMedicationScheduleRepository:
    MedicationScheduleRepository {

    var schedules: [MedicationSchedule] = []

    func fetchMedicationSchedules() throws -> [MedicationSchedule] {
        schedules
    }

    func saveMedicationSchedule(
        _ schedule: MedicationSchedule
    ) throws {
        schedules.append(schedule)
    }

    func deleteMedicationSchedule(id: UUID) throws {
        schedules.removeAll { $0.id == id }
    }
}

struct ManageMedicationSchedulesUseCaseTests {
    
    @Test
    func getsSchedulesForPetStaySortedByTime() throws {

        let repository = MockManageMedicationScheduleRepository()

        let useCase = ManageMedicationSchedulesUseCase(
            medicationScheduleRepository: repository
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

        let eveningSchedule = MedicationSchedule(
            petStayID: targetStayID,
            medicationName: "Carprofen",
            dosage: "25 mg",
            scheduledTime: calendar.date(
                bySettingHour: 20,
                minute: 0,
                second: 0,
                of: date
            )!,
            minimumIntervalHours: 12
        )

        let morningSchedule = MedicationSchedule(
            petStayID: targetStayID,
            medicationName: "Carprofen",
            dosage: "25 mg",
            scheduledTime: calendar.date(
                bySettingHour: 8,
                minute: 0,
                second: 0,
                of: date
            )!,
            minimumIntervalHours: 12
        )

        let otherStaySchedule = MedicationSchedule(
            petStayID: otherStayID,
            medicationName: "Other Medicine",
            dosage: "10 mg",
            scheduledTime: calendar.date(
                bySettingHour: 7,
                minute: 0,
                second: 0,
                of: date
            )!,
            minimumIntervalHours: 8
        )

        repository.schedules = [
            eveningSchedule,
            otherStaySchedule,
            morningSchedule
        ]

        let result = try useCase.getSchedules(
            for: targetStayID
        )

        #expect(result.count == 2)

        #expect(result[0].id == morningSchedule.id)
        #expect(result[1].id == eveningSchedule.id)

        #expect(
            result.allSatisfy {
                $0.petStayID == targetStayID
            }
        )
    }
    
    @Test
    func createsMedicationSchedule() throws {

        let repository = MockManageMedicationScheduleRepository()

        let useCase = ManageMedicationSchedulesUseCase(
            medicationScheduleRepository: repository
        )

        let petStayID = UUID()

        let scheduledTime = Calendar.current.date(
            from: DateComponents(
                year: 2026,
                month: 10,
                day: 4,
                hour: 8
            )
        )!

        let result = try useCase.createSchedule(
            petStayID: petStayID,
            medicationName: "Carprofen",
            dosage: "25 mg",
            scheduledTime: scheduledTime,
            minimumIntervalHours: 12
        )

        #expect(repository.schedules.count == 1)

        #expect(result.petStayID == petStayID)
        #expect(result.medicationName == "Carprofen")
        #expect(result.dosage == "25 mg")
        #expect(result.scheduledTime == scheduledTime)
        #expect(result.minimumIntervalHours == 12)

        #expect(
            repository.schedules.first?.id == result.id
        )
    }
    
    @Test
    func deletesMedicationSchedule() throws {

        let repository = MockManageMedicationScheduleRepository()

        let useCase = ManageMedicationSchedulesUseCase(
            medicationScheduleRepository: repository
        )

        let scheduleToDelete = MedicationSchedule(
            petStayID: UUID(),
            medicationName: "Carprofen",
            dosage: "25 mg",
            scheduledTime: Date(),
            minimumIntervalHours: 12
        )

        let scheduleToKeep = MedicationSchedule(
            petStayID: UUID(),
            medicationName: "Other Medicine",
            dosage: "10 mg",
            scheduledTime: Date(),
            minimumIntervalHours: 8
        )

        repository.schedules = [
            scheduleToDelete,
            scheduleToKeep
        ]

        try useCase.deleteSchedule(
            id: scheduleToDelete.id
        )

        #expect(repository.schedules.count == 1)

        #expect(
            repository.schedules.first?.id == scheduleToKeep.id
        )

        #expect(
            repository.schedules.contains {
                $0.id == scheduleToDelete.id
            } == false
        )
    }
    
    @Test
    func rejectsInvalidMinimumInterval() throws {
        let repository =
            MockManageMedicationScheduleRepository()

        let useCase =
            ManageMedicationSchedulesUseCase(
                medicationScheduleRepository: repository
            )

        let petStayID = UUID()

        #expect(
            throws:
                ManageMedicationSchedulesError
                    .invalidMinimumInterval
        ) {
            try useCase.createSchedule(
                petStayID: petStayID,
                medicationName: "Carprofen",
                dosage: "25 mg",
                scheduledTime: Date(),
                minimumIntervalHours: 0
            )
        }

        #expect(
            throws:
                ManageMedicationSchedulesError
                    .invalidMinimumInterval
        ) {
            try useCase.createSchedule(
                petStayID: petStayID,
                medicationName: "Carprofen",
                dosage: "25 mg",
                scheduledTime: Date(),
                minimumIntervalHours: -1
            )
        }

        #expect(repository.schedules.isEmpty)
    }
}
