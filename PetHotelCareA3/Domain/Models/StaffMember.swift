//
//  StaffMember.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/2.
//

import Foundation

struct StaffMember: Identifiable, Equatable {
    let id: UUID
    var name: String

    init(
        id: UUID = UUID(),
        name: String
    ) {
        self.id = id
        self.name = name
    }
}
