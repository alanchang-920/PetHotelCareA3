//
//  PetOwner.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/2.
//

import Foundation

struct PetOwner: Identifiable, Equatable {
    let id: UUID
    var name: String
    var phoneNumber: String

    init(
        id: UUID = UUID(),
        name: String,
        phoneNumber: String
    ) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
    }
}
