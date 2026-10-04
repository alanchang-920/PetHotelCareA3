//
//  GetPetStayDetailUseCase.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/4.
//

import Foundation

final class GetPetStayDetailUseCase {

    private let petStayRepository: PetStayRepository

    init(petStayRepository: PetStayRepository) {
        self.petStayRepository = petStayRepository
    }

    func execute(petStayID: UUID) throws -> PetStay {
        let petStays = try petStayRepository.fetchPetStays()

        guard let petStay = petStays.first(where: {
            $0.id == petStayID
        }) else {
            throw PetStayDetailError.petStayNotFound
        }

        return petStay
    }
}
