//
//  GetCurrentPetStaysUseCase.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/4.
//

import Foundation

final class GetCurrentPetStaysUseCase {

    private let petStayRepository: PetStayRepository

    init(petStayRepository: PetStayRepository) {
        self.petStayRepository = petStayRepository
    }

    func execute(for date: Date = Date()) throws -> [PetStay] {
        let petStays = try petStayRepository.fetchPetStays()

        return petStays
            .filter { petStay in
                petStay.checkInDate <= date &&
                petStay.checkOutDate >= date
            }
            .sorted {
                $0.roomNumber.localizedStandardCompare($1.roomNumber)
                    == .orderedAscending
            }
    }
}
