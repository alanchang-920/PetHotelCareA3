//
//  MedicationScheduleRepository.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/3.
//

import Foundation

protocol MedicationScheduleRepository {
    func fetchMedicationSchedules() throws -> [MedicationSchedule]
    func saveMedicationSchedule(_ schedule: MedicationSchedule) throws
    func deleteMedicationSchedule(id: UUID) throws
}
