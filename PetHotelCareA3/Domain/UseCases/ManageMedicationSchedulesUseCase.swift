//
//  ManageMedicationSchedulesUseCase.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/4.
//

import Foundation

final class ManageMedicationSchedulesUseCase {

    private let medicationScheduleRepository: MedicationScheduleRepository

    init(
        medicationScheduleRepository: MedicationScheduleRepository
    ) {
        self.medicationScheduleRepository = medicationScheduleRepository
    }

    func getSchedules(for petStayID: UUID) throws -> [MedicationSchedule] {

        let schedules = try medicationScheduleRepository
            .fetchMedicationSchedules()

        return schedules
            .filter { $0.petStayID == petStayID }
            .sorted { $0.scheduledTime < $1.scheduledTime }
    }

    @discardableResult
    func createSchedule(
        petStayID: UUID,
        medicationName: String,
        dosage: String,
        scheduledTime: Date,
        minimumIntervalHours: Double
    ) throws -> MedicationSchedule {

        let schedule = MedicationSchedule(
            petStayID: petStayID,
            medicationName: medicationName,
            dosage: dosage,
            scheduledTime: scheduledTime,
            minimumIntervalHours: minimumIntervalHours
        )

        try medicationScheduleRepository
            .saveMedicationSchedule(schedule)

        return schedule
    }

    func deleteSchedule(id: UUID) throws {
        try medicationScheduleRepository
            .deleteMedicationSchedule(id: id)
    }
}
