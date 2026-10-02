//
//  PetStay.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/2.
//

import Foundation

struct PetStay: Identifiable, Equatable {
    let id: UUID
    let pet: Pet
    var roomNumber: String
    var checkInDate: Date
    var checkOutDate: Date
    var feedingInstructions: String
    var careNotes: String

    init(
        id: UUID = UUID(),
        pet: Pet,
        roomNumber: String,
        checkInDate: Date,
        checkOutDate: Date,
        feedingInstructions: String,
        careNotes: String
    ) {
        self.id = id
        self.pet = pet
        self.roomNumber = roomNumber
        self.checkInDate = checkInDate
        self.checkOutDate = checkOutDate
        self.feedingInstructions = feedingInstructions
        self.careNotes = careNotes
    }
}
