//
//  PetStayRepository.swift
//  PetHotelCareA3
//
//  Created by Chang Chia ming on 2026/10/3.
//

import Foundation

protocol PetStayRepository {
    func fetchPetStays() throws -> [PetStay]
    func savePetStay(_ petStay: PetStay) throws
    func deletePetStay(id: UUID) throws
}

