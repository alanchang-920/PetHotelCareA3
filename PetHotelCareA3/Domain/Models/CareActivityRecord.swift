//
//  CareActivityRecord.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/2.
//

import Foundation

struct CareActivityRecord: Identifiable, Equatable {
    let id: UUID
    let petStayID: UUID
    let careTaskID: UUID
    let taskType: CareTaskType
    let completedBy: StaffMember
    let completedAt: Date
    var notes: String

    init(
        id: UUID = UUID(),
        petStayID: UUID,
        careTaskID: UUID,
        taskType: CareTaskType,
        completedBy: StaffMember,
        completedAt: Date = Date(),
        notes: String
    ) {
        self.id = id
        self.petStayID = petStayID
        self.careTaskID = careTaskID
        self.taskType = taskType
        self.completedBy = completedBy
        self.completedAt = completedAt
        self.notes = notes
    }
}
