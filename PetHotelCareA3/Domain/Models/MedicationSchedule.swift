//
//  MedicationSchedule.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/2.
//

import Foundation

struct MedicationSchedule: Identifiable, Equatable {
    let id: UUID
    let petStayID: UUID
    var medicationName: String
    var dosage: String
    var scheduledTime: Date
    var minimumIntervalHours: Double

    init(
        id: UUID = UUID(),
        petStayID: UUID,
        medicationName: String,
        dosage: String,
        scheduledTime: Date,
        minimumIntervalHours: Double
    ) {
        self.id = id
        self.petStayID = petStayID
        self.medicationName = medicationName
        self.dosage = dosage
        self.scheduledTime = scheduledTime
        self.minimumIntervalHours = minimumIntervalHours
    }
}
