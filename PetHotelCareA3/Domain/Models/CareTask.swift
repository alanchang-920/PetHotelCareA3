//
//  CareTask.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/2.
//

import Foundation

struct CareTask: Identifiable, Equatable {
    let id: UUID
    let petStayID: UUID
    var type: CareTaskType
    var scheduledTime: Date
    var instructions: String
    var isCompleted: Bool

    init(
        id: UUID = UUID(),
        petStayID: UUID,
        type: CareTaskType,
        scheduledTime: Date,
        instructions: String,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.petStayID = petStayID
        self.type = type
        self.scheduledTime = scheduledTime
        self.instructions = instructions
        self.isCompleted = isCompleted
    }
}

enum CareTaskType: String, CaseIterable {
    case feeding = "Feeding"
    case walk = "Walk"
    case medication = "Medication"
}
