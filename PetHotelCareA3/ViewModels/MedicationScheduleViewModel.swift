//
//  MedicationScheduleViewModel.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/5.
//

import Foundation
import Combine

@MainActor
final class MedicationScheduleViewModel: ObservableObject {

    @Published private(set) var schedules: [MedicationSchedule] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let manageMedicationSchedulesUseCase:
        ManageMedicationSchedulesUseCase

    init(
        manageMedicationSchedulesUseCase:
            ManageMedicationSchedulesUseCase
    ) {
        self.manageMedicationSchedulesUseCase =
            manageMedicationSchedulesUseCase
    }

    func loadSchedules(for petStayID: UUID) {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            schedules =
                try manageMedicationSchedulesUseCase
                    .getSchedules(for: petStayID)
        } catch {
            schedules = []
            errorMessage = "Unable to load medication schedules."
        }
    }

    func createSchedule(
        petStayID: UUID,
        medicationName: String,
        dosage: String,
        scheduledTime: Date,
        minimumIntervalHours: Double
    ) {
        errorMessage = nil

        do {
            try manageMedicationSchedulesUseCase.createSchedule(
                petStayID: petStayID,
                medicationName: medicationName,
                dosage: dosage,
                scheduledTime: scheduledTime,
                minimumIntervalHours: minimumIntervalHours
            )

            loadSchedules(for: petStayID)

        } catch {
            errorMessage = "Unable to create medication schedule."
        }
    }

    func deleteSchedule(_ schedule: MedicationSchedule) {
        errorMessage = nil

        do {
            try manageMedicationSchedulesUseCase.deleteSchedule(
                id: schedule.id
            )

            loadSchedules(for: schedule.petStayID)

        } catch {
            errorMessage = "Unable to delete medication schedule."
        }
    }
}
