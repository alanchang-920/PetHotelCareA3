//
//  CreatePetStayUseCase.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/4.
//

import Foundation

final class CreatePetStayUseCase {

    private let petStayRepository: PetStayRepository

    init(petStayRepository: PetStayRepository) {
        self.petStayRepository = petStayRepository
    }

    func execute(
        pet: Pet,
        roomNumber: String,
        checkInDate: Date,
        checkOutDate: Date,
        feedingInstructions: String,
        careNotes: String
    ) throws -> PetStay {

        guard checkOutDate > checkInDate else {
            throw CreatePetStayError.invalidStayDates
        }

        let petStay = PetStay(
            pet: pet,
            roomNumber: roomNumber,
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            feedingInstructions: feedingInstructions,
            careNotes: careNotes
        )

        try petStayRepository.savePetStay(petStay)

        return petStay
    }
}
